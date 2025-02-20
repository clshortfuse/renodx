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
  float _39 = max((TEXCOORD.x), (cb0_015x));
  float _40 = max((TEXCOORD.y), (cb0_015y));
  float _41 = min(_39, (cb0_015z));
  float _42 = min(_40, (cb0_015w));
  float4 _45 = ColorTexture.Sample(ColorSampler, float2(_41, _42));
  float _54 = (cb0_036x) * (TEXCOORD.x);
  float _55 = (cb0_036y) * (TEXCOORD.y);
  float _56 = _54 + (cb0_036z);
  float _57 = _55 + (cb0_036w);
  float _63 = max(_56, (cb0_037x));
  float _64 = max(_57, (cb0_037y));
  float _65 = min(_63, (cb0_037z));
  float _66 = min(_64, (cb0_037w));
  float4 _69 = BloomTexture.Sample(BloomSampler, float2(_65, _66));
  float _78 = (cb0_048z) * (TEXCOORD_3.x);
  float _79 = (cb0_048w) * (TEXCOORD_3.y);
  float _80 = _78 + (cb0_048x);
  float _81 = _79 + (cb0_048y);
  float _82 = _80 * 0.5f;
  float _83 = _81 * 0.5f;
  float _84 = _82 + 0.5f;
  float _85 = 0.5f - _83;
  float4 _88 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2(_84, _85));
  float _96 = (cb0_045x) * (_88.x);
  float _97 = (cb0_045y) * (_88.y);
  float _98 = (cb0_045z) * (_88.z);
  float _99 = _96 + 1.0f;
  float _100 = _97 + 1.0f;
  float _101 = _98 + 1.0f;
  float _102 = _99 * (_69.x);
  float _103 = _100 * (_69.y);
  float _104 = _101 * (_69.z);
  float _107 = (cb0_047x) * (TEXCOORD_1.x);
  float _108 = (cb0_047x) * (TEXCOORD_1.y);
  float _109 = dot(float2(_107, _108), float2(_107, _108));
  float _110 = _109 + 1.0f;
  float _111 = 1.0f / _110;
  float _112 = _111 * _111;
  float4 _118 = SceneColorApplyParamaters[0].data[0 / 4];
  float _122 = _30 * (_32.x);
  float _123 = _122 * _112;
  float _124 = (cb0_044x) * (_45.x);
  float _125 = _124 * _123;
  float _126 = _125 * (_118.x);
  float _127 = (cb0_044y) * (_45.y);
  float _128 = _127 * _123;
  float _129 = _128 * (_118.y);
  float _130 = (cb0_044z) * (_45.z);
  float _131 = _130 * _123;
  float _132 = _131 * (_118.z);

  untonemapped = float3(_126, _129, _132);

  float _133 = _102 * _123;
  float _134 = _103 * _123;
  float _135 = _104 * _123;
  float _136 = _133 + 0.002667719265446067f;
  float _137 = _136 + _126;
  float _138 = _134 + 0.002667719265446067f;
  float _139 = _138 + _129;
  float _140 = _135 + 0.002667719265446067f;
  float _141 = _140 + _132;
  float _142 = log2(_137);
  float _143 = log2(_139);
  float _144 = log2(_141);
  float _145 = _142 * 0.0714285746216774f;
  float _146 = _143 * 0.0714285746216774f;
  float _147 = _144 * 0.0714285746216774f;
  float _148 = _145 + 0.6107269525527954f;
  float _149 = _146 + 0.6107269525527954f;
  float _150 = _147 + 0.6107269525527954f;
  float _151 = saturate(_148);
  float _152 = saturate(_149);
  float _153 = saturate(_150);
  float _156 = (cb0_050z) * _151;
  float _157 = (cb0_050z) * _152;
  float _158 = (cb0_050z) * _153;
  float _160 = _156 + (cb0_050w);
  float _161 = _157 + (cb0_050w);
  float _162 = _158 + (cb0_050w);
  float4 _165 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3(_160, _161, _162));
  return LutToneMap(untonemapped, float3(_160, _161, _162), ColorGradingLUT, ColorGradingLUTSampler);

  float _169 = (_165.x) * 1.0499999523162842f;
  float _170 = (_165.y) * 1.0499999523162842f;
  float _171 = (_165.z) * 1.0499999523162842f;
  float _172 = dot(float3(_169, _170, _171), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  bool _175 = (((uint)(cb0_051z)) == 0);
  float _246 = _169;
  float _247 = _170;
  float _248 = _171;
  if (!_175) {
    float _177 = log2(_169);
    float _178 = log2(_170);
    float _179 = log2(_171);
    float _180 = _177 * 0.012683313339948654f;
    float _181 = _178 * 0.012683313339948654f;
    float _182 = _179 * 0.012683313339948654f;
    float _183 = exp2(_180);
    float _184 = exp2(_181);
    float _185 = exp2(_182);
    float _186 = _183 + -0.8359375f;
    float _187 = _184 + -0.8359375f;
    float _188 = _185 + -0.8359375f;
    float _189 = max(0.0f, _186);
    float _190 = max(0.0f, _187);
    float _191 = max(0.0f, _188);
    float _192 = _183 * 18.6875f;
    float _193 = _184 * 18.6875f;
    float _194 = _185 * 18.6875f;
    float _195 = 18.8515625f - _192;
    float _196 = 18.8515625f - _193;
    float _197 = 18.8515625f - _194;
    float _198 = _189 / _195;
    float _199 = _190 / _196;
    float _200 = _191 / _197;
    float _201 = log2(_198);
    float _202 = log2(_199);
    float _203 = log2(_200);
    float _204 = _201 * 6.277394771575928f;
    float _205 = _202 * 6.277394771575928f;
    float _206 = _203 * 6.277394771575928f;
    float _207 = exp2(_204);
    float _208 = exp2(_205);
    float _209 = exp2(_206);
    float _210 = _207 * 10000.0f;
    float _211 = _208 * 10000.0f;
    float _212 = _209 * 10000.0f;
    float _215 = _210 / (cb0_051x);
    float _216 = _211 / (cb0_051x);
    float _217 = _212 / (cb0_051x);
    float _218 = max(6.103519990574569e-05f, _215);
    float _219 = max(6.103519990574569e-05f, _216);
    float _220 = max(6.103519990574569e-05f, _217);
    float _221 = max(_218, 0.0031306699384003878f);
    float _222 = max(_219, 0.0031306699384003878f);
    float _223 = max(_220, 0.0031306699384003878f);
    float _224 = log2(_221);
    float _225 = log2(_222);
    float _226 = log2(_223);
    float _227 = _224 * 0.4166666567325592f;
    float _228 = _225 * 0.4166666567325592f;
    float _229 = _226 * 0.4166666567325592f;
    float _230 = exp2(_227);
    float _231 = exp2(_228);
    float _232 = exp2(_229);
    float _233 = _230 * 1.0549999475479126f;
    float _234 = _231 * 1.0549999475479126f;
    float _235 = _232 * 1.0549999475479126f;
    float _236 = _233 + -0.054999999701976776f;
    float _237 = _234 + -0.054999999701976776f;
    float _238 = _235 + -0.054999999701976776f;
    float _239 = _218 * 12.920000076293945f;
    float _240 = _219 * 12.920000076293945f;
    float _241 = _220 * 12.920000076293945f;
    float _242 = min(_239, _236);
    float _243 = min(_240, _237);
    float _244 = min(_241, _238);
    _246 = _242;
    _247 = _243;
    _248 = _244;
  }
  float _249 = (TEXCOORD_2.w) * 543.3099975585938f;
  float _250 = _249 + (TEXCOORD_2.z);
  float _251 = sin(_250);
  float _252 = _251 * 493013.0f;
  float _253 = frac(_252);
  float _254 = _253 * 2.0f;
  float _255 = _254 + -1.0f;
  float _256 = _255 * 0x7FF0000000000000;
  float _257 = max(_256, -1.0f);
  float _258 = min(_257, 1.0f);
  float _259 = abs(_255);
  float _260 = 1.0f - _259;
  float _261 = saturate(_260);
  float _262 = sqrt(_261);
  float _263 = _262 * _258;
  float _264 = _258 - _263;
  float _267 = _264 * (cb0_051y);
  float _268 = _267 + _246;
  float _269 = _267 + _247;
  float _270 = _267 + _248;
  SV_Target.x = _268;
  SV_Target.y = _269;
  SV_Target.z = _270;
  SV_Target.w = 0.0f;
  SV_Target_1 = _172;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

// Enotria Sample Shader 1

#include "./common.hlsl"

struct _EyeAdaptationBuffer {
  float data[4];
};
StructuredBuffer<_EyeAdaptationBuffer> EyeAdaptationBuffer : register(t0);

Texture2D<float4> ColorTexture : register(t1);

Texture2D<float4> BloomTexture : register(t2);

struct _SceneColorApplyParamaters {
  float data[4];
};
StructuredBuffer<_SceneColorApplyParamaters> SceneColorApplyParamaters : register(t3);

Texture2D<float4> BloomDirtMaskTexture : register(t4);

Texture3D<float4> ColorGradingLUT : register(t5);

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

cbuffer View : register(b1) {
  float View_143w : packoffset(c143.w);
};

SamplerState ColorSampler : register(s0);

SamplerState BloomSampler : register(s1);

SamplerState BloomDirtMaskSampler : register(s2);

SamplerState ColorGradingLUTSampler : register(s3);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float SV_Target_1 : SV_Target1;
};

OutputSignature main(
    noperspective float2 TEXCOORD : TEXCOORD,
    noperspective float2 TEXCOORD_1 : TEXCOORD1,
    noperspective float4 TEXCOORD_2 : TEXCOORD2,
    noperspective float2 TEXCOORD_3 : TEXCOORD3,
    noperspective float2 TEXCOORD_4 : TEXCOORD4,
    noperspective float4 SV_Position : SV_Position) {
  float4 SV_Target;
  float SV_Target_1;
  float4 _26 = EyeAdaptationBuffer[0].data[0 / 4];
  float _33 = max(TEXCOORD.x, cb0_015x);
  float _34 = max(TEXCOORD.y, cb0_015y);
  float _35 = min(_33, cb0_015z);
  float _36 = min(_34, cb0_015w);
  float4 _39 = ColorTexture.Sample(ColorSampler, float2(_35, _36));
  float _48 = (cb0_036x)*TEXCOORD.x;
  float _49 = (cb0_036y)*TEXCOORD.y;
  float _50 = _48 + (cb0_036z);
  float _51 = _49 + (cb0_036w);
  float _57 = max(_50, cb0_037x);
  float _58 = max(_51, cb0_037y);
  float _59 = min(_57, cb0_037z);
  float _60 = min(_58, cb0_037w);
  float4 _63 = BloomTexture.Sample(BloomSampler, float2(_59, _60));
  float _72 = cb0_048z * TEXCOORD_3.x;
  float _73 = cb0_048w * TEXCOORD_3.y;
  float _74 = _72 + cb0_048x;
  float _75 = _73 + cb0_048y;
  float _76 = _74 * 0.5f;
  float _77 = _75 * 0.5f;
  float _78 = _76 + 0.5f;
  float _79 = 0.5f - _77;
  float4 _82 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2(_78, _79));
  float _90 = cb0_045x * _82.x;
  float _91 = cb0_045y * _82.y;
  float _92 = cb0_045z * _82.z;
  float _93 = _90 + 1.0f;
  float _94 = _91 + 1.0f;
  float _95 = _92 + 1.0f;
  float _96 = _93 * (_63.x);
  float _97 = _94 * (_63.y);
  float _98 = _95 * (_63.z);
  float _101 = cb0_047x * TEXCOORD_1.x;
  float _102 = cb0_047x * TEXCOORD_1.y;
  float _103 = dot(float2(_101, _102), float2(_101, _102));
  float _104 = _103 + 1.0f;
  float _105 = 1.0f / _104;
  float _106 = _105 * _105;
  float4 _112 = SceneColorApplyParamaters[0].data[0 / 4];
  float _116 = (_26.x) * View_143w;
  float _117 = _116 * _106;
  float _118 = cb0_044x * _39.x;
  float _119 = _118 * _117;
  float _120 = _119 * _112.x;
  float _121 = cb0_044y * _39.y;
  float _122 = _121 * _117;
  float _123 = _122 * _112.y;
  float _124 = cb0_044z * _39.z;
  float _125 = _124 * _117;
  float _126 = _125 * _112.z;

  float3 untonemapped = float3(_120, _123, _126);

  float _127 = _96 * _117;
  float _128 = _97 * _117;
  float _129 = _98 * _117;
  float _130 = _127 + 0.002667719265446067f;
  float _131 = _130 + _120;
  float _132 = _128 + 0.002667719265446067f;
  float _133 = _132 + _123;
  float _134 = _129 + 0.002667719265446067f;
  float _135 = _134 + _126;
  float _136 = log2(_131);
  float _137 = log2(_133);
  float _138 = log2(_135);
  float _139 = _136 * 0.0714285746216774f;
  float _140 = _137 * 0.0714285746216774f;
  float _141 = _138 * 0.0714285746216774f;
  float _142 = _139 + 0.6107269525527954f;
  float _143 = _140 + 0.6107269525527954f;
  float _144 = _141 + 0.6107269525527954f;
  float _145 = saturate(_142);
  float _146 = saturate(_143);
  float _147 = saturate(_144);
  float _150 = cb0_050z * _145;
  float _151 = cb0_050z * _146;
  float _152 = cb0_050z * _147;
  float _154 = _150 + cb0_050w;
  float _155 = _151 + cb0_050w;
  float _156 = _152 + cb0_050w;
  float4 _159 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3(_154, _155, _156));

  float3 tonemapped = float3(_159.r, _159.g, _159.b);

  float _163 = _159.x * 1.0499999523162842f;
  float _164 = _159.y * 1.0499999523162842f;
  float _165 = _159.z * 1.0499999523162842f;
  float _166 = dot(float3(_163, _164, _165), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  bool _169 = ((uint)(cb0_051z) == 0);
  float _240;
  float _241;
  float _242;
  [branch] if (!_169) {
    float _171 = log2(_163);
    float _172 = log2(_164);
    float _173 = log2(_165);
    float _174 = _171 * 0.012683313339948654f;
    float _175 = _172 * 0.012683313339948654f;
    float _176 = _173 * 0.012683313339948654f;
    float _177 = exp2(_174);
    float _178 = exp2(_175);
    float _179 = exp2(_176);
    float _180 = _177 + -0.8359375f;
    float _181 = _178 + -0.8359375f;
    float _182 = _179 + -0.8359375f;
    float _183 = max(0.0f, _180);
    float _184 = max(0.0f, _181);
    float _185 = max(0.0f, _182);
    float _186 = _177 * 18.6875f;
    float _187 = _178 * 18.6875f;
    float _188 = _179 * 18.6875f;
    float _189 = 18.8515625f - _186;
    float _190 = 18.8515625f - _187;
    float _191 = 18.8515625f - _188;
    float _192 = _183 / _189;
    float _193 = _184 / _190;
    float _194 = _185 / _191;
    float _195 = log2(_192);
    float _196 = log2(_193);
    float _197 = log2(_194);
    float _198 = _195 * 6.277394771575928f;
    float _199 = _196 * 6.277394771575928f;
    float _200 = _197 * 6.277394771575928f;
    float _201 = exp2(_198);
    float _202 = exp2(_199);
    float _203 = exp2(_200);
    float _204 = _201 * 10000.0f;
    float _205 = _202 * 10000.0f;
    float _206 = _203 * 10000.0f;
    float _209 = _204 / cb0_051x;
    float _210 = _205 / cb0_051x;
    float _211 = _206 / cb0_051x;
    float _212 = max(6.103519990574569e-05f, _209);
    float _213 = max(6.103519990574569e-05f, _210);
    float _214 = max(6.103519990574569e-05f, _211);
    float _215 = max(_212, 0.0031306699384003878f);
    float _216 = max(_213, 0.0031306699384003878f);
    float _217 = max(_214, 0.0031306699384003878f);
    float _218 = log2(_215);
    float _219 = log2(_216);
    float _220 = log2(_217);
    float _221 = _218 * 0.4166666567325592f;
    float _222 = _219 * 0.4166666567325592f;
    float _223 = _220 * 0.4166666567325592f;
    float _224 = exp2(_221);
    float _225 = exp2(_222);
    float _226 = exp2(_223);
    float _227 = _224 * 1.0549999475479126f;
    float _228 = _225 * 1.0549999475479126f;
    float _229 = _226 * 1.0549999475479126f;
    float _230 = _227 + -0.054999999701976776f;
    float _231 = _228 + -0.054999999701976776f;
    float _232 = _229 + -0.054999999701976776f;
    float _233 = _212 * 12.920000076293945f;
    float _234 = _213 * 12.920000076293945f;
    float _235 = _214 * 12.920000076293945f;
    float _236 = min(_233, _230);
    float _237 = min(_234, _231);
    float _238 = min(_235, _232);
    _240 = _236;
    _241 = _237;
    _242 = _238;
  }
  else {
    _240 = _163;
    _241 = _164;
    _242 = _165;
  }
  float _243 = TEXCOORD_2.w * 543.3099975585938f;
  float _244 = _243 + TEXCOORD_2.z;
  float _245 = sin(_244);
  float _246 = _245 * 493013.0f;
  float _247 = frac(_246);
  float _248 = _247 * 2.0f;
  float _249 = _248 + -1.0f;
  // float _250 = _249 * +1. #INF;
  float _250 = _249 * 9999.f;
  float _251 = max(_250, -1.0f);
  float _252 = min(_251, 1.0f);
  float _253 = abs(_249);
  float _254 = 1.0f - _253;
  float _255 = saturate(_254);
  float _256 = sqrt(_255);
  float _257 = _256 * _252;
  float _258 = _252 - _257;
  float _261 = _258 * cb0_051y;
  float _262 = _261 + _240;
  float _263 = _261 + _241;
  float _264 = _261 + _242;

  if (RENODX_TONE_MAP_TYPE != 0) {
    SV_Target = ProcessColor(untonemapped, tonemapped);
    SV_Target_1 = _166;
    OutputSignature output_signature = {SV_Target, SV_Target_1};
    return output_signature;
  }

  SV_Target.x = _262;
  SV_Target.y = _263;
  SV_Target.z = _264;
  SV_Target.w = 0.0f;
  SV_Target_1 = _166;
  OutputSignature output_signature = {SV_Target, SV_Target_1};
  return output_signature;
}

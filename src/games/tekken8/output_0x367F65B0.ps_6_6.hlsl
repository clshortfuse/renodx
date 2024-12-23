
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

cbuffer _RootShaderParameters : register(b0) {
  float _RootShaderParameters_015x : packoffset(c015.x);
  float _RootShaderParameters_015y : packoffset(c015.y);
  float _RootShaderParameters_015z : packoffset(c015.z);
  float _RootShaderParameters_015w : packoffset(c015.w);
  float _RootShaderParameters_033x : packoffset(c033.x);
  float _RootShaderParameters_033y : packoffset(c033.y);
  float _RootShaderParameters_033z : packoffset(c033.z);
  float _RootShaderParameters_033w : packoffset(c033.w);
  float _RootShaderParameters_034x : packoffset(c034.x);
  float _RootShaderParameters_034y : packoffset(c034.y);
  float _RootShaderParameters_034z : packoffset(c034.z);
  float _RootShaderParameters_034w : packoffset(c034.w);
  float _RootShaderParameters_041x : packoffset(c041.x);
  float _RootShaderParameters_041y : packoffset(c041.y);
  float _RootShaderParameters_041z : packoffset(c041.z);
  float _RootShaderParameters_042x : packoffset(c042.x);
  float _RootShaderParameters_042y : packoffset(c042.y);
  float _RootShaderParameters_042z : packoffset(c042.z);
  float _RootShaderParameters_044x : packoffset(c044.x);
  float _RootShaderParameters_045x : packoffset(c045.x);
  float _RootShaderParameters_045y : packoffset(c045.y);
  float _RootShaderParameters_045z : packoffset(c045.z);
  float _RootShaderParameters_045w : packoffset(c045.w);
  float _RootShaderParameters_047z : packoffset(c047.z);
  float _RootShaderParameters_047w : packoffset(c047.w);
  float _RootShaderParameters_048x : packoffset(c048.x);
  uint _RootShaderParameters_048y : packoffset(c048.y);
};

cbuffer UniformBufferConstants_View : register(b1) {
  float UniformBufferConstants_View_136z : packoffset(c136.z);
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
  noperspective float4 SV_Position : SV_Position
) {
  float4 SV_Target;

  float SV_Target_1;
  // texture _1 = ColorGradingLUT;
  // texture _2 = BloomDirtMaskTexture;
  // texture _3 = SceneColorApplyParamaters;
  // texture _4 = BloomTexture;
  // texture _5 = ColorTexture;
  // texture _6 = EyeAdaptationBuffer;
  // SamplerState _7 = ColorGradingLUTSampler;
  // SamplerState _8 = BloomDirtMaskSampler;
  // SamplerState _9 = BloomSampler;
  // SamplerState _10 = ColorSampler;
  // cbuffer _11 = UniformBufferConstants_View;
  // cbuffer _12 = _RootShaderParameters;
  // _13 = _11;
  // _14 = _12;
  float _15 = TEXCOORD_3.x;
  float _16 = TEXCOORD_3.y;
  float _17 = TEXCOORD_2.z;
  float _18 = TEXCOORD_2.w;
  float _19 = TEXCOORD_1.x;
  float _20 = TEXCOORD_1.y;
  float _21 = TEXCOORD.x;
  float _22 = TEXCOORD.y;
  float _24 = _RootShaderParameters_015z;
  float _25 = _RootShaderParameters_015w;
  float _26 = _RootShaderParameters_015x;
  float _27 = _RootShaderParameters_015y;
  float _28 = max(_21, _26);
  float _29 = max(_22, _27);
  float _30 = min(_28, _24);
  float _31 = min(_29, _25);
  // _32 = _5;
  // _33 = _10;
  float4 _34 = ColorTexture.Sample(ColorSampler, float2(_30, _31));
  float _35 = _34.x;
  float _36 = _34.y;
  float _37 = _34.z;
  float _39 = UniformBufferConstants_View_136z;
  float _40 = _39 * _35;
  float _41 = _39 * _36;
  float _42 = _39 * _37;
  // _43 = _6;
  float4 _44 = EyeAdaptationBuffer[0].data[0 / 4];
  float _45 = _44.x;
  float _47 = _RootShaderParameters_041x;
  float _48 = _RootShaderParameters_041y;
  float _49 = _RootShaderParameters_041z;
  float _50 = _40 * _47;
  float _51 = _41 * _48;
  float _52 = _42 * _49;
  // _53 = _3;
  float4 _54 = SceneColorApplyParamaters[0].data[0 / 4];
  float _55 = _54.x;
  float _56 = _54.y;
  float _57 = _54.z;
  float _58 = _50 * _55;
  float _59 = _51 * _56;
  float _60 = _52 * _57;
  float _62 = _RootShaderParameters_033x;
  float _63 = _RootShaderParameters_033y;
  float _64 = _RootShaderParameters_033z;
  float _65 = _RootShaderParameters_033w;
  float _66 = _62 * _21;
  float _67 = _63 * _22;
  float _68 = _66 + _64;
  float _69 = _67 + _65;
  float _71 = _RootShaderParameters_034z;
  float _72 = _RootShaderParameters_034w;
  float _73 = _RootShaderParameters_034x;
  float _74 = _RootShaderParameters_034y;
  float _75 = max(_68, _73);
  float _76 = max(_69, _74);
  float _77 = min(_75, _71);
  float _78 = min(_76, _72);
  // _79 = _4;
  // _80 = _9;
  float4 _81 = BloomTexture.Sample(BloomSampler, float2(_77, _78));
  float _82 = _81.x;
  float _83 = _81.y;
  float _84 = _81.z;
  float _86 = UniformBufferConstants_View_136z;
  float _87 = _86 * _82;
  float _88 = _86 * _83;
  float _89 = _86 * _84;
  float _91 = _RootShaderParameters_045x;
  float _92 = _RootShaderParameters_045y;
  float _93 = _RootShaderParameters_045z;
  float _94 = _RootShaderParameters_045w;
  float _95 = _93 * _15;
  float _96 = _94 * _16;
  float _97 = _95 + _91;
  float _98 = _96 + _92;
  float _99 = _97 * 0.5f;
  float _100 = _98 * 0.5f;
  float _101 = _99 + 0.5f;
  float _102 = 0.5f - _100;
  // _103 = _2;
  // _104 = _8;
  float4 _105 = BloomDirtMaskTexture.Sample(BloomDirtMaskSampler, float2(_101, _102));
  float _106 = _105.x;
  float _107 = _105.y;
  float _108 = _105.z;
  float _110 = _RootShaderParameters_042x;
  float _111 = _RootShaderParameters_042y;
  float _112 = _RootShaderParameters_042z;
  float _113 = _110 * _106;
  float _114 = _111 * _107;
  float _115 = _112 * _108;
  float _116 = _113 + 1.0f;
  float _117 = _114 + 1.0f;
  float _118 = _115 + 1.0f;
  float _119 = _87 * _116;
  float _120 = _88 * _117;
  float _121 = _89 * _118;
  float _122 = _119 + _58;
  float _123 = _120 + _59;
  float _124 = _121 + _60;
  float _126 = _RootShaderParameters_044x;
  float _127 = _126 * _19;
  float _128 = _126 * _20;
  float _129 = dot(float2(_127, _128), float2(_127, _128));
  float _130 = _129 + 1.0f;
  float _131 = 1.0f / _130;
  float _132 = _131 * _131;
  float _133 = _132 * _45;
  float _134 = _133 * _122;
  float _135 = _133 * _123;
  float _136 = _133 * _124;
  float _137 = _134 + 0.002667719265446067f;
  float _138 = _135 + 0.002667719265446067f;
  float _139 = _136 + 0.002667719265446067f;
  float _140 = log2(_137);
  float _141 = log2(_138);
  float _142 = log2(_139);
  float _143 = _140 * 0.0714285746216774f;
  float _144 = _141 * 0.0714285746216774f;
  float _145 = _142 * 0.0714285746216774f;
  float _146 = _143 + 0.6107269525527954f;
  float _147 = _144 + 0.6107269525527954f;
  float _148 = _145 + 0.6107269525527954f;
  float _149 = saturate(_146);
  float _150 = saturate(_147);
  float _151 = saturate(_148);
  float _153 = _RootShaderParameters_047z;
  float _154 = _153 * _149;
  float _155 = _153 * _150;
  float _156 = _153 * _151;
  float _157 = _RootShaderParameters_047w;
  float _158 = _154 + _157;
  float _159 = _155 + _157;
  float _160 = _156 + _157;
  // _161 = _1;
  // _162 = _7;
  float4 _163 = ColorGradingLUT.Sample(ColorGradingLUTSampler, float3(_158, _159, _160));

  float _164 = _163.x;
  float _165 = _163.y;
  float _166 = _163.z;
  float _167 = _164 * 1.0499999523162842f;
  float _168 = _165 * 1.0499999523162842f;
  float _169 = _166 * 1.0499999523162842f;
  float _170 = dot(float3(_167, _168, _169), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float _171 = _18 * 543.3099975585938f;
  float _172 = _171 + _17;
  float _173 = sin(_172);
  float _174 = _173 * 493013.0f;
  float _175 = frac(_174);
  float _176 = _175 * 0.00390625f;
  float _177 = _176 + -0.001953125f;
  float _178 = _177 + _167;
  float _179 = _177 + _168;
  float _180 = _177 + _169;
  uint _182 = _RootShaderParameters_048y;
  bool _183 = (_182 == 0);
  float _254 = _178;
  float _255 = _179;
  float _256 = _180;
  if (!_183) {
    float _185 = log2(_178);
    float _186 = log2(_179);
    float _187 = log2(_180);
    float _188 = _185 * 0.012683313339948654f;
    float _189 = _186 * 0.012683313339948654f;
    float _190 = _187 * 0.012683313339948654f;
    float _191 = exp2(_188);
    float _192 = exp2(_189);
    float _193 = exp2(_190);
    float _194 = _191 + -0.8359375f;
    float _195 = _192 + -0.8359375f;
    float _196 = _193 + -0.8359375f;
    float _197 = max(0.0f, _194);
    float _198 = max(0.0f, _195);
    float _199 = max(0.0f, _196);
    float _200 = _191 * 18.6875f;
    float _201 = _192 * 18.6875f;
    float _202 = _193 * 18.6875f;
    float _203 = 18.8515625f - _200;
    float _204 = 18.8515625f - _201;
    float _205 = 18.8515625f - _202;
    float _206 = _197 / _203;
    float _207 = _198 / _204;
    float _208 = _199 / _205;
    float _209 = log2(_206);
    float _210 = log2(_207);
    float _211 = log2(_208);
    float _212 = _209 * 6.277394771575928f;
    float _213 = _210 * 6.277394771575928f;
    float _214 = _211 * 6.277394771575928f;
    float _215 = exp2(_212);
    float _216 = exp2(_213);
    float _217 = exp2(_214);
    float _218 = _215 * 10000.0f;
    float _219 = _216 * 10000.0f;
    float _220 = _217 * 10000.0f;
    float _222 = _RootShaderParameters_048x;
    float _223 = _218 / _222;
    float _224 = _219 / _222;
    float _225 = _220 / _222;
    float _226 = max(6.103519990574569e-05f, _223);
    float _227 = max(6.103519990574569e-05f, _224);
    float _228 = max(6.103519990574569e-05f, _225);
    float _229 = max(_226, 0.0031306699384003878f);
    float _230 = max(_227, 0.0031306699384003878f);
    float _231 = max(_228, 0.0031306699384003878f);
    float _232 = log2(_229);
    float _233 = log2(_230);
    float _234 = log2(_231);
    float _235 = _232 * 0.4166666567325592f;
    float _236 = _233 * 0.4166666567325592f;
    float _237 = _234 * 0.4166666567325592f;
    float _238 = exp2(_235);
    float _239 = exp2(_236);
    float _240 = exp2(_237);
    float _241 = _238 * 1.0549999475479126f;
    float _242 = _239 * 1.0549999475479126f;
    float _243 = _240 * 1.0549999475479126f;
    float _244 = _241 + -0.054999999701976776f;
    float _245 = _242 + -0.054999999701976776f;
    float _246 = _243 + -0.054999999701976776f;
    float _247 = _226 * 12.920000076293945f;
    float _248 = _227 * 12.920000076293945f;
    float _249 = _228 * 12.920000076293945f;
    float _250 = min(_247, _244);
    float _251 = min(_248, _245);
    float _252 = min(_249, _246);
    _254 = _250;
    _255 = _251;
    _256 = _252;
  }
  SV_Target.x = _254;
  SV_Target.y = _255;
  SV_Target.z = _256;

  SV_Target.w = 0.0f;
  SV_Target_1 = _170;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}

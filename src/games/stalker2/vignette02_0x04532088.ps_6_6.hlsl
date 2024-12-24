#include "./common.hlsl"

Texture2D<float4> SceneTexturesStruct_SceneDepthTexture : register(t0);

Texture2D<float4> PostProcessInput_0_Texture : register(t1);

cbuffer $Globals : register(b0) {
  float $Globals_004x : packoffset(c004.x);
  float $Globals_004y : packoffset(c004.y);
  float $Globals_005x : packoffset(c005.x);
  float $Globals_005y : packoffset(c005.y);
  float $Globals_006x : packoffset(c006.x);
  float $Globals_006y : packoffset(c006.y);
  float $Globals_006z : packoffset(c006.z);
  float $Globals_006w : packoffset(c006.w);
  uint $Globals_072x : packoffset(c072.x);
  uint $Globals_072y : packoffset(c072.y);
  float $Globals_073z : packoffset(c073.z);
  float $Globals_073w : packoffset(c073.w);
};

cbuffer UniformBufferConstants_View : register(b1) {
  float UniformBufferConstants_View_052x : packoffset(c052.x);
  float UniformBufferConstants_View_052y : packoffset(c052.y);
  float UniformBufferConstants_View_052w : packoffset(c052.w);
  float UniformBufferConstants_View_053x : packoffset(c053.x);
  float UniformBufferConstants_View_053y : packoffset(c053.y);
  float UniformBufferConstants_View_053w : packoffset(c053.w);
  float UniformBufferConstants_View_054x : packoffset(c054.x);
  float UniformBufferConstants_View_054y : packoffset(c054.y);
  float UniformBufferConstants_View_054w : packoffset(c054.w);
  float UniformBufferConstants_View_055x : packoffset(c055.x);
  float UniformBufferConstants_View_055y : packoffset(c055.y);
  float UniformBufferConstants_View_055w : packoffset(c055.w);
  float UniformBufferConstants_View_077x : packoffset(c077.x);
  float UniformBufferConstants_View_077y : packoffset(c077.y);
  float UniformBufferConstants_View_080x : packoffset(c080.x);
  float UniformBufferConstants_View_080y : packoffset(c080.y);
  float UniformBufferConstants_View_132x : packoffset(c132.x);
  float UniformBufferConstants_View_132y : packoffset(c132.y);
  float UniformBufferConstants_View_133x : packoffset(c133.x);
  float UniformBufferConstants_View_133y : packoffset(c133.y);
  float UniformBufferConstants_View_136z : packoffset(c136.z);
  float UniformBufferConstants_View_136w : packoffset(c136.w);
};

cbuffer UniformBufferConstants_Material : register(b2) {
  float UniformBufferConstants_Material_001x : packoffset(c001.x);
  float UniformBufferConstants_Material_001y : packoffset(c001.y);
  float UniformBufferConstants_Material_001z : packoffset(c001.z);
  float UniformBufferConstants_Material_004y : packoffset(c004.y);
  float UniformBufferConstants_Material_004z : packoffset(c004.z);
  float UniformBufferConstants_Material_005x : packoffset(c005.x);
  float UniformBufferConstants_Material_005y : packoffset(c005.y);
  float UniformBufferConstants_Material_005z : packoffset(c005.z);
  float UniformBufferConstants_Material_006x : packoffset(c006.x);
  float UniformBufferConstants_Material_006y : packoffset(c006.y);
  float UniformBufferConstants_Material_006z : packoffset(c006.z);
  float UniformBufferConstants_Material_006w : packoffset(c006.w);
  float UniformBufferConstants_Material_007x : packoffset(c007.x);
  float UniformBufferConstants_Material_007y : packoffset(c007.y);
  float UniformBufferConstants_Material_007z : packoffset(c007.z);
};

SamplerState SceneTexturesStruct_PointClampSampler : register(s0);

SamplerState PostProcessInput_0_Sampler : register(s1);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float3 tonemappedRender, post_srgb, output, srgb_input;

  // texture _1 = PostProcessInput_0_Texture;
  // texture _2 = SceneTexturesStruct_SceneDepthTexture;
  // SamplerState _3 = PostProcessInput_0_Sampler;
  // SamplerState _4 = SceneTexturesStruct_PointClampSampler;
  // cbuffer _5 = UniformBufferConstants_Material;
  // cbuffer _6 = UniformBufferConstants_View;
  // cbuffer _7 = $Globals;
  // _8 = _5;
  // _9 = _6;
  // _10 = _7;
  float _11 = SV_Position.x;
  float _12 = SV_Position.y;
  float _14 = UniformBufferConstants_View_077x;
  float _15 = UniformBufferConstants_View_077y;
  float _17 = UniformBufferConstants_View_080x;
  float _18 = UniformBufferConstants_View_080y;
  uint _20 = $Globals_072x;
  uint _21 = $Globals_072y;
  float _22 = float(_20);
  float _23 = float(_21);
  float _24 = _11 - _22;
  float _25 = _12 - _23;
  float _27 = $Globals_073z;
  float _28 = $Globals_073w;
  float _29 = _24 * _27;
  float _30 = _25 * _28;
  float _32 = UniformBufferConstants_View_133x;
  float _33 = UniformBufferConstants_View_133y;
  float _34 = _29 * _32;
  float _35 = _30 * _33;
  float _37 = UniformBufferConstants_View_132x;
  float _38 = UniformBufferConstants_View_132y;
  float _39 = _34 + _37;
  float _40 = _35 + _38;
  float _42 = UniformBufferConstants_View_136z;
  float _43 = UniformBufferConstants_View_136w;
  float _44 = _39 * _42;
  float _45 = _40 * _43;
  // _46 = _2;
  // _47 = _4;
  float4 _48 = SceneTexturesStruct_SceneDepthTexture.SampleLevel(SceneTexturesStruct_PointClampSampler, float2(_44, _45), 0.0f);
  
  float _49 = _48.x;
  float _50 = max(_49, 1.000000045813705e-18f);
  float _52 = UniformBufferConstants_View_052x;
  float _53 = UniformBufferConstants_View_052y;
  float _54 = UniformBufferConstants_View_052w;
  float _56 = UniformBufferConstants_View_053x;
  float _57 = UniformBufferConstants_View_053y;
  float _58 = UniformBufferConstants_View_053w;
  float _60 = UniformBufferConstants_View_054x;
  float _61 = UniformBufferConstants_View_054y;
  float _62 = UniformBufferConstants_View_054w;
  float _64 = UniformBufferConstants_View_055x;
  float _65 = UniformBufferConstants_View_055y;
  float _66 = UniformBufferConstants_View_055w;
  float _67 = _52 * _11;
  float _68 = mad(_12, _56, _67);
  float _69 = mad(_50, _60, _68);
  float _70 = _69 + _64;
  float _71 = _53 * _11;
  float _72 = mad(_12, _57, _71);
  float _73 = mad(_50, _61, _72);
  float _74 = _73 + _65;
  float _75 = _54 * _11;
  float _76 = mad(_12, _58, _75);
  float _77 = mad(_50, _62, _76);
  float _78 = _77 + _66;
  float _79 = _70 / _78;
  float _80 = _74 / _78;
  float _81 = _79 - _17;
  float _82 = _80 - _18;
  float _83 = _29 + -0.5f;
  float _84 = _30 + -0.5f;
  float _86 = UniformBufferConstants_Material_001x;
  float _87 = _86 * _83;
  float _88 = _86 * _84;
  float _89 = _87 * _87;
  float _90 = _88 * _88;
  float _91 = _89 + _90;
  float _92 = sqrt(_91);
  float _93 = saturate(_92);
  float _94 = UniformBufferConstants_Material_001y;
  bool _95 = (_93 <= 0.0f);
  float _96 = log2(_93);
  float _97 = _96 * _94;
  float _98 = exp2(_97);
  float _99 = 1.0f - _98;
  float _100 = _95 ? 1.0f : _99;
  float _101 = UniformBufferConstants_Material_001z;
  float _102 = _100 + _101;
  float _103 = saturate(_102);
  float _105 = $Globals_005x;
  float _106 = $Globals_005y;
  float _107 = _105 * _29;
  float _108 = _106 * _30;
  float _110 = $Globals_004x;
  float _111 = $Globals_004y;
  float _112 = _107 + _110;
  float _113 = _108 + _111;
  float _115 = $Globals_006x;
  float _116 = $Globals_006y;
  float _117 = $Globals_006z;
  float _118 = $Globals_006w;
  float _119 = max(_112, _115);
  float _120 = max(_113, _116);
  float _121 = min(_119, _117);
  float _122 = min(_120, _118);
  // _123 = _1;
  // _124 = _3;
  float4 _125 = PostProcessInput_0_Texture.Sample(PostProcessInput_0_Sampler, float2(_121, _122));
  if (injectedData.toneMapType > 0.f) {
    // We decode before they attempt to blend
    tonemappedRender = PQToDecoded(_125.rgb);
    srgb_input = DecodedTosRGB(tonemappedRender);
    _125.rgb = srgb_input;
  }

  float _126 = _125.x;
  float _127 = _125.y;
  float _128 = _125.z;
  float _129 = 1.0f - _126;
  float _130 = 1.0f - _127;
  float _131 = 1.0f - _128;
  float _132 = _129 * 2.0f;
  float _133 = _130 * 2.0f;
  float _134 = _131 * 2.0f;
  float _135 = _81 - _14;
  float _136 = _82 - _15;
  float _137 = _135 * _135;
  float _138 = _136 * _136;
  float _139 = _138 + _137;
  float _140 = _139 * 3.875007814624354e-10f;
  float _141 = sqrt(_140);
  float _143 = UniformBufferConstants_Material_004y;
  float _144 = UniformBufferConstants_Material_004z;
  float _145 = _141 * 50800.0f;
  float _146 = _145 * _143;
  bool _147 = (_146 <= 0.0f);
  float _148 = log2(_146);
  float _149 = _148 * _144;
  float _150 = exp2(_149);
  float _151 = _147 ? 0.0f : _150;
  float _152 = saturate(_151);
  float _154 = UniformBufferConstants_Material_005x;
  float _155 = UniformBufferConstants_Material_005y;
  float _156 = UniformBufferConstants_Material_005z;
  float _158 = UniformBufferConstants_Material_006x;
  float _159 = UniformBufferConstants_Material_006y;
  float _160 = UniformBufferConstants_Material_006z;
  float _161 = _154 - _158;
  float _162 = _155 - _159;
  float _163 = _156 - _160;
  float _164 = _161 * _152;
  float _165 = _162 * _152;
  float _166 = _163 * _152;
  float _167 = _164 + _158;
  float _168 = _165 + _159;
  float _169 = _166 + _160;
  float _170 = 1.0f - _167;
  float _171 = 1.0f - _168;
  float _172 = 1.0f - _169;
  float _173 = _132 * _170;
  float _174 = _133 * _171;
  float _175 = _134 * _172;
  float _176 = 1.0f - _173;
  float _177 = 1.0f - _174;
  float _178 = 1.0f - _175;
  float _179 = _126 * 2.0f;
  float _180 = _127 * 2.0f;
  float _181 = _128 * 2.0f;
  float _182 = _179 * _167;
  float _183 = _180 * _168;
  float _184 = _181 * _169;
  bool _185 = (_126 >= 0.5f);
  float _186 = _185 ? _176 : _182;
  bool _187 = (_127 >= 0.5f);
  float _188 = _187 ? _177 : _183;
  bool _189 = (_128 >= 0.5f);
  float _190 = _189 ? _178 : _184;
  float _191 = _186 * _103;
  float _192 = _188 * _103;
  float _193 = _190 * _103;
  float _194 = UniformBufferConstants_Material_006w;
  float _196 = UniformBufferConstants_Material_007x;
  float _197 = UniformBufferConstants_Material_007y;
  float _198 = UniformBufferConstants_Material_007z;
  float _199 = _196 - _191;
  float _200 = _197 - _192;
  float _201 = _198 - _193;
  float _202 = _199 * _194;
  float _203 = _200 * _194;
  float _204 = _201 * _194;
  float _205 = _202 + _191;
  float _206 = _203 + _192;
  float _207 = _204 + _193;
  float _208 = max(_205, 0.0f);
  float _209 = max(_206, 0.0f);
  float _210 = max(_207, 0.0f);

  post_srgb = float3(_208, _209, _210);

  if (injectedData.toneMapType > 0.f) {
    output = UpgradePostProcess(tonemappedRender, post_srgb, injectedData.vignetteStrength);
    return float4(output, 0.f);
  }

  SV_Target.x = _208;
  SV_Target.y = _209;
  SV_Target.z = _210;
  SV_Target.w = 0.0f;
  return SV_Target;
}

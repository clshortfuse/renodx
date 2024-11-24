#include "./shared.h"
#include "./tonemapper.hlsl"

Texture2D<float4> Material_Texture2D_0 : register(t0);

Texture2D<float4> PostProcessInput_0_Texture : register(t1);

Texture2D<float4> EyeAdaptationTexture : register(t2);

cbuffer $Globals : register(b0) {
  float $Globals_004x : packoffset(c004.x);
  float $Globals_004y : packoffset(c004.y);
  float $Globals_005x : packoffset(c005.x);
  float $Globals_005y : packoffset(c005.y);
  uint $Globals_072x : packoffset(c072.x);
  uint $Globals_072y : packoffset(c072.y);
  float $Globals_073z : packoffset(c073.z);
  float $Globals_073w : packoffset(c073.w);
};

cbuffer UniformBufferConstants_View : register(b1) {
  float UniformBufferConstants_View_133x : packoffset(c133.x);
  float UniformBufferConstants_View_133y : packoffset(c133.y);
  float UniformBufferConstants_View_147y : packoffset(c147.y);
};

cbuffer UniformBufferConstants_MaterialCollection0 : register(b2) {
  float UniformBufferConstants_MaterialCollection0_000w : packoffset(c000.w);
  float UniformBufferConstants_MaterialCollection0_004w : packoffset(c004.w);
  float UniformBufferConstants_MaterialCollection0_019w : packoffset(c019.w);
};

cbuffer UniformBufferConstants_Material : register(b3) {
  float UniformBufferConstants_Material_001x : packoffset(c001.x);
  float UniformBufferConstants_Material_001y : packoffset(c001.y);
  float UniformBufferConstants_Material_001z : packoffset(c001.z);
  float UniformBufferConstants_Material_001w : packoffset(c001.w);
  float UniformBufferConstants_Material_002y : packoffset(c002.y);
  float UniformBufferConstants_Material_002w : packoffset(c002.w);
  float UniformBufferConstants_Material_003x : packoffset(c003.x);
  float UniformBufferConstants_Material_003y : packoffset(c003.y);
  float UniformBufferConstants_Material_003z : packoffset(c003.z);
  float UniformBufferConstants_Material_003w : packoffset(c003.w);
  float UniformBufferConstants_Material_004x : packoffset(c004.x);
  float UniformBufferConstants_Material_004y : packoffset(c004.y);
  float UniformBufferConstants_Material_004z : packoffset(c004.z);
  float UniformBufferConstants_Material_006x : packoffset(c006.x);
  float UniformBufferConstants_Material_006y : packoffset(c006.y);
  float UniformBufferConstants_Material_006z : packoffset(c006.z);
  float UniformBufferConstants_Material_006w : packoffset(c006.w);
  float UniformBufferConstants_Material_007x : packoffset(c007.x);
  float UniformBufferConstants_Material_007y : packoffset(c007.y);
  float UniformBufferConstants_Material_007z : packoffset(c007.z);
};

SamplerState Material_Wrap_WorldGroupSettings : register(s0);

SamplerState PostProcessInput_0_Sampler : register(s1);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  // texture _1 = EyeAdaptationTexture;
  // texture _2 = PostProcessInput_0_Texture;
  // texture _3 = Material_Texture2D_0;
  // SamplerState _4 = PostProcessInput_0_Sampler;
  // SamplerState _5 = Material_Wrap_WorldGroupSettings;
  // cbuffer _6 = UniformBufferConstants_Material;
  // cbuffer _7 = UniformBufferConstants_MaterialCollection0;
  // cbuffer _8 = UniformBufferConstants_View;
  // cbuffer _9 = $Globals;
  // _10 = _6;
  // _11 = _7;
  // _12 = _8;
  // _13 = _9;
  float _14 = SV_Position.x;
  float _15 = SV_Position.y;
  uint _17 = $Globals_072x;
  uint _18 = $Globals_072y;
  float _19 = float(_17);
  float _20 = float(_18);
  float _21 = _14 - _19;
  float _22 = _15 - _20;
  float _24 = $Globals_073z;
  float _25 = $Globals_073w;
  float _26 = _21 * _24;
  float _27 = _22 * _25;
  float _29 = UniformBufferConstants_View_133x;
  float _30 = UniformBufferConstants_View_133y;
  float _31 = _30 / _29;
  float _32 = _27 * _31;
  float _33 = _31 * 0.5f;
  float _34 = 0.5f - _33;
  float _35 = _34 + _32;
  float _37 = UniformBufferConstants_MaterialCollection0_019w;
  float _38 = _37 * 0.7799999713897705f;
  float _39 = _37 + _26;
  float _40 = _35 + _38;
  float _41 = _39 + 0.23000000417232513f;
  float _42 = _40 + 0.23000000417232513f;
  float _44 = UniformBufferConstants_Material_001x;
  float _45 = _41 * _44;
  float _46 = _42 * _44;
  // _47 = _3;
  // _48 = _5;
  float4 _49 = Material_Texture2D_0.Sample(Material_Wrap_WorldGroupSettings, float2(_45, _46));
  // Increase dots brightness
  float _50 = _49.x ;
  float _51 = _39 * 16.0f;
  float _52 = _40 * 16.0f;
  // _53 = _3;
  // _54 = _5;
  float4 _55 = Material_Texture2D_0.Sample(Material_Wrap_WorldGroupSettings, float2(_51, _52));
  float _56 = _55.y;
  float _58 = UniformBufferConstants_MaterialCollection0_004w;
  bool _59 = (_58 <= 0.0f);
  float _60 = log2(_58);
  float _61 = _60 * 0.20000000298023224f;
  float _62 = exp2(_61);
  float _63 = _59 ? 0.0f : _62;
  float _64 = saturate(_63);
  float _65 = _64 * 0.25f;
  bool _66 = (_65 < _56);
  float _67 = _66 ? 0.0f : 1.0f;
  float _68 = _39 * 14.0f;
  float _69 = _40 * 14.0f;
  // _70 = _3;
  // _71 = _5;
  float4 _72 = Material_Texture2D_0.Sample(Material_Wrap_WorldGroupSettings, float2(_68, _69));
  float _73 = _72.z;
  float _74 = _73 + _50;
  float _75 = _74 * _67;
  float _76 = 1.0f - _26;
  float _77 = 1.0f - _27;
  float _79 = UniformBufferConstants_Material_001y;
  bool _80 = (_76 <= 0.0f);
  float _81 = log2(_76);
  float _82 = _81 * _79;
  float _83 = exp2(_82);
  float _84 = _80 ? 0.0f : _83;
  bool _85 = (_77 <= 0.0f);
  float _86 = log2(_77);
  float _87 = _86 * _79;
  float _88 = exp2(_87);
  float _89 = _85 ? 0.0f : _88;
  bool _90 = (_26 <= 0.0f);
  float _91 = log2(_26);
  float _92 = _91 * _79;
  float _93 = exp2(_92);
  float _94 = _90 ? 0.0f : _93;
  bool _95 = (_27 <= 0.0f);
  float _96 = log2(_27);
  float _97 = _96 * _79;
  float _98 = exp2(_97);
  float _99 = _95 ? 0.0f : _98;
  float _100 = _94 * _84;
  float _101 = _99 * _89;
  float _102 = UniformBufferConstants_Material_001z;
  float _103 = _100 * _102;
  float _104 = _101 * _102;
  float _105 = saturate(_103);
  float _106 = saturate(_104);
  float _107 = 2.0f - _105;
  float _108 = _107 - _106;
  float _109 = _75 * _108;
  float _110 = UniformBufferConstants_Material_001w;
  float _111 = _109 * _110;
  uint _113 = $Globals_072x;
  uint _114 = $Globals_072y;
  float _115 = float(_113);
  float _116 = float(_114);
  float _117 = _14 - _115;
  float _118 = _15 - _116;
  float _120 = $Globals_073z;
  float _121 = $Globals_073w;
  float _122 = _117 * _120;
  float _123 = _118 * _121;
  float _125 = $Globals_005x;
  float _126 = $Globals_005y;
  float _127 = _122 * _125;
  float _128 = _123 * _126;
  float _130 = $Globals_004x;
  float _131 = $Globals_004y;
  float _132 = _127 + _130;
  float _133 = _128 + _131;
  // _134 = _2;
  // _135 = _4;
  float4 _136 = PostProcessInput_0_Texture.Sample(PostProcessInput_0_Sampler, float2(_132, _133));

  // We decode before they attempt to blend
  float3 inputBT709 = renodx::color::pq::Decode(_136.rgb, injectedData.toneMapGameNits);
  inputBT709 = renodx::color::bt709::from::BT2020(inputBT709.rgb);

  // We only want the overlay on top so we have a black background
  _136.rgb = float3(0.f, 0.f, 0.f);

  float _137 = _136.x;
  float _138 = _136.y;
  float _139 = _136.z;

  // _140 = _1;
  float4 _141 = EyeAdaptationTexture.Load(int3(0, 0, 0));
  float _142 = _141.x;
  float _143 = saturate(_142);
  float _145 = UniformBufferConstants_MaterialCollection0_000w;
  float _147 = UniformBufferConstants_Material_002y;
  bool _148 = (_145 <= 0.0f);
  float _149 = log2(_145);
  float _150 = _149 * _147;
  float _151 = exp2(_150);
  float _152 = _148 ? 0.0f : _151;
  float _153 = saturate(_152);
  float _154 = _153 * _143;
  float _155 = _26 + -0.5f;
  float _156 = _27 + -0.5f;
  float _157 = _155 * _155;
  float _158 = _156 * _156;
  float _159 = _157 + _158;
  float _160 = sqrt(_159);
  float _161 = UniformBufferConstants_Material_002w;
  float _162 = _161 * _160;
  float _163 = 1.0f - _162;
  float _165 = UniformBufferConstants_Material_003x;
  float _166 = _163 * _165;
  float _167 = _166 * _166;
  float _168 = _167 * 1.442695140838623f;
  float _169 = exp2(_168);
  float _170 = 1.0f / _169;
  float _171 = abs(_163);
  bool _172 = (_171 > 9.999999747378752e-06f);
  bool _173 = (_163 >= 0.0f);
  bool _174 = _173 && _172;
  float _175 = 1.0f - _170;
  float _176 = _174 ? _175 : 0.0f;
  float _177 = saturate(_176);
  float _178 = 1.0f - _177;
  float _179 = _154 * _178;
  float _180 = _179 * _137;
  float _181 = _179 * _138;
  float _182 = _179 * _139;
  float _183 = UniformBufferConstants_Material_003y;
  float _184 = _183 - _137;
  float _185 = _183 - _138;
  float _186 = _183 - _139;
  float _187 = _180 * _184;
  float _188 = _181 * _185;
  float _189 = _182 * _186;
  float _190 = _187 + _137;
  float _191 = _188 + _138;
  float _192 = _189 + _139;

  float _193 = saturate(_190);
  float _194 = saturate(_191);
  float _195 = saturate(_192);
  // Remove saturates
  /* _193 = _190;
  _194 = _191;
  _195 = _192; */

  float _196 = _137 + 0.25999999046325684f;
  float _197 = _138 + 0.25999999046325684f;
  float _198 = _139 + 0.25999999046325684f;
  float _199 = _137 + -0.5f;
  float _200 = abs(_199);
  bool _201 = (_200 > 9.999999747378752e-06f);
  bool _202 = (_137 >= 0.5f);
  float _203 = _202 ? 1.0f : 0.0f;
  float _204 = _201 ? _203 : 1.0f;
  float _205 = UniformBufferConstants_Material_003z;
  float _206 = _122 * _205;
  float _207 = _123 * _205;
  float _208 = _206 + _39;
  float _209 = _207 + _40;
  float _210 = _208 * _205;
  float _211 = _209 * _205;

  // _212 = _3;
  // _213 = _5;
  float4 _214 = Material_Texture2D_0.Sample(Material_Wrap_WorldGroupSettings, float2(_210, _211));
  float _215 = _214.w;
  float _217 = UniformBufferConstants_Material_003w;
  float _218 = _217 * _215;
  float _219 = 1.0f - _143;
  float _220 = _219 * 0.03999999910593033f;
  float _221 = _220 + 0.3199999928474426f;
  float _222 = _221 + _218;
  float _223 = _222 * _204;
  float _224 = _196 * 2.0f;
  float _225 = _224 * _223;
  float _226 = _197 * 2.0f;
  float _227 = _226 * _223;
  float _228 = _198 * 2.0f;
  float _229 = _228 * _223;
  float _230 = 1.0f - _204;
  float _231 = 0.7400000095367432f - _137;
  float _232 = 0.7400000095367432f - _138;
  float _233 = 0.7400000095367432f - _139;
  float _234 = 1.0f - _222;
  float _235 = _231 * 2.0f;
  float _236 = _235 * _234;
  float _237 = _232 * 2.0f;
  float _238 = _237 * _234;
  float _239 = _233 * 2.0f;
  float _240 = _239 * _234;
  float _241 = 1.0f - _236;
  float _242 = 1.0f - _238;
  float _243 = 1.0f - _240;
  float _244 = _241 * _230;
  float _245 = _242 * _230;
  float _246 = _243 * _230;
  float _247 = _244 + _225;
  float _248 = _245 + _227;
  float _249 = _246 + _229;
  float _250 = 2.0f - _143;
  float _251 = _250 * 0.5f;
  float _252 = _247 * _251;
  float _253 = _248 * _251;
  float _254 = _249 * _251;
  float _255 = dot(float3(_252, _253, _254), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
  float _257 = UniformBufferConstants_Material_004x;
  float _258 = _255 - _252;
  float _259 = _255 - _253;
  float _260 = _255 - _254;
  float _261 = _258 * _257;
  float _262 = _259 * _257;
  float _263 = _260 * _257;
  float _264 = _35 + -0.5f;
  float _265 = _264 * _264;
  float _266 = _265 + _157;
  float _267 = sqrt(_266);
  float _268 = _219 * 0.10000000149011612f;
  float _269 = _268 + 0.4000000059604645f;
  float _270 = _267 / _269;
  float _271 = 1.0f - _270;
  float _272 = _271 * _271;
  float _273 = _272 * 5.770780563354492f;
  float _274 = exp2(_273);
  float _275 = 1.0f / _274;
  float _276 = abs(_271);
  bool _277 = (_276 > 9.999999747378752e-06f);
  bool _278 = (_271 >= 0.0f);
  bool _279 = _278 && _277;
  float _280 = 1.0f - _275;
  float _281 = _279 ? _280 : 0.0f;
  float _282 = saturate(_281);
  // _282 = _281;

  float _283 = 1.0f - _282;
  float _284 = _219 * 0.33000001311302185f;
  float _285 = _284 + 0.5f;
  float _286 = UniformBufferConstants_Material_004y;
  float _287 = _286 - _285;
  float _288 = _287 * 0.5f;
  float _290 = UniformBufferConstants_View_147y;
  float _291 = UniformBufferConstants_Material_004z;
  float _292 = _290 * 6.2831854820251465f;
  float _293 = _292 * _291;
  float _294 = sin(_293);
  float _295 = _294 + 1.0f;
  float _296 = _288 * _295;
  float _297 = _296 + _285;
  float _298 = _283 * _153;
  float _299 = _298 * _297;
  float _300 = _252 - _193;
  float _301 = _300 + _261;
  float _302 = _253 - _194;
  float _303 = _302 + _262;
  float _304 = _254 - _195;
  float _305 = _304 + _263;
  float _306 = _299 * _301;
  float _307 = _299 * _303;
  float _308 = _299 * _305;
  float _310 = UniformBufferConstants_Material_006x;
  float _311 = UniformBufferConstants_Material_006y;
  float _312 = UniformBufferConstants_Material_006z;
  float _313 = _179 * _310;
  float _314 = _179 * _311;
  float _315 = _179 * _312;
  float _316 = _193 + _111;
  float _317 = _316 + _313;
  float _318 = _317 + _306;
  float _319 = _194 + _111;
  float _320 = _319 + _314;
  float _321 = _320 + _307;
  float _322 = _195 + _111;
  float _323 = _322 + _315;
  float _324 = _323 + _308;
  float _325 = UniformBufferConstants_Material_006w;
  float _327 = UniformBufferConstants_Material_007x;
  float _328 = UniformBufferConstants_Material_007y;
  float _329 = UniformBufferConstants_Material_007z;
  float _330 = _327 - _318;
  float _331 = _328 - _321;
  float _332 = _329 - _324;
  float _333 = _330 * _325;
  float _334 = _331 * _325;
  float _335 = _332 * _325;
  float _336 = _333 + _318;
  float _337 = _334 + _321;
  float _338 = _335 + _324;
  float _339 = max(_336, 0.0f);
  float _340 = max(_337, 0.0f);
  float _341 = max(_338, 0.0f);

  float3 overlay = float3(_339, _340, _341);
  if (injectedData.toneMapGammaCorrection == 1.f) {
      overlay = renodx::color::correct::GammaSafe(overlay);
  }

  // Lerp overlay with original
  // hardcode, smarter approach would to understand how they lerp it
  float3 output = lerp(inputBT709, overlay, 0.125f);

  output = renodx::color::bt2020::from::BT709(output);
  output = renodx::color::pq::Encode(output, injectedData.toneMapGameNits);
  return float4(output, 0.f);

  SV_Target.x = _339;
  SV_Target.y = _340;
  SV_Target.z = _341;
  SV_Target.w = 0.0f;
  return SV_Target;
}

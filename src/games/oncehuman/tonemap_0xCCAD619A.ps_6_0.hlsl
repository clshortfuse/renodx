// =====================================================================================
// Once Human - Tonemap & Color Grade Pass (Gameplay / Variant)
// API: DX12 (sm6)
// 
// RenoDX Injection Details:
// - Verbatim DXC decompile of the game pass.
// - Custom effect-strength sliders multiplied in at each effect source.
// - Bypasses vanilla display-gamma encode in favor of RenoDX tone mapping.
// =====================================================================================
#include "./shared.h"

Texture2D<float4> AutoExposureTex : register(t0);

Texture2D<float4> BloomTex : register(t1);

Texture2D<float4> ColorGradingLut : register(t2);

Texture2D<float4> BgTex : register(t3);

cbuffer $Globals : register(b0) {
  float4 Tint : packoffset(c000.x);
  float GrayScale : packoffset(c001.x);
  float ChromaticAberrationRange : packoffset(c001.y);
  float ChromaticAberrationIntensity : packoffset(c001.z);
  float MaxBrightness : packoffset(c001.w);
  float MinBrightness : packoffset(c002.x);
  float BrightnessFactor : packoffset(c002.y);
};

SamplerState Sampler_Bilinear_Clamp : register(s0);

float4 main(
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float _9 = TEXCOORD.x * 2.0f;
  float _10 = TEXCOORD.y * 2.0f;
  float _11 = _9 + -1.0f;
  float _12 = _10 + -1.0f;
  float _13 = abs(_11);
  float _14 = abs(_12);
  float _17 = 1.0f - ChromaticAberrationRange;
  float _18 = max(_17, 0.0f);
  float _19 = min(_18, 1.0f);
  float _20 = 1.0f - _19;
  float _21 = _13 - _19;
  float _22 = _14 - _19;
  float _23 = _21 / _20;
  float _24 = _22 / _20;
  float _25 = saturate(_23);
  float _26 = saturate(_24);
  float _27 = _25 * 2.0f;
  float _28 = _26 * 2.0f;
  float _29 = 3.0f - _27;
  float _30 = 3.0f - _28;
  float _31 = TEXCOORD.x + -0.5f;
  float _32 = TEXCOORD.y + -0.5f;
  bool _33 = (_31 > 0.0f);
  bool _34 = (_32 > 0.0f);
  bool _35 = (_31 < 0.0f);
  bool _36 = (_32 < 0.0f);
  int _37 = (int)(uint)(_33);
  int _38 = (int)(uint)(_34);
  int _39 = (int)(uint)(_35);
  int _40 = (int)(uint)(_36);
  int _41 = _37 - _39;
  int _42 = _38 - _40;
  float _43 = float((int)(_41));
  float _44 = float((int)(_42));
  float _46 = _43 * 0.029999999329447746f;
  float _47 = _25 * _25;
  float _48 = _47 * _46;
  float _49 = _48 * _29;
  float _50 = _49 * (ChromaticAberrationIntensity * shader_injection.chromatic_aberration_strength);  // RENODX: Chromatic Aberration Strength
  float _51 = _44 * 0.029999999329447746f;
  float _52 = _26 * _26;
  float _53 = _52 * _51;
  float _54 = _53 * _30;
  float _55 = _54 * (ChromaticAberrationIntensity * shader_injection.chromatic_aberration_strength);  // RENODX: Chromatic Aberration Strength
  float _56 = _50 * 0.33333298563957214f;
  float _57 = _55 * 0.33333298563957214f;
  float4 _58 = BgTex.Sample(Sampler_Bilinear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));
  float _60 = TEXCOORD.x - _56;
  float _61 = TEXCOORD.y - _57;
  float4 _62 = BgTex.Sample(Sampler_Bilinear_Clamp, float2(_60, _61));
  float _64 = _50 * 0.6666659712791443f;
  float _65 = _55 * 0.6666659712791443f;
  float _66 = TEXCOORD.x - _64;
  float _67 = TEXCOORD.y - _65;
  float4 _68 = BgTex.Sample(Sampler_Bilinear_Clamp, float2(_66, _67));
  float4 _70 = AutoExposureTex.Sample(Sampler_Bilinear_Clamp, float2(0.5f, 0.5f));
  float _72 = _70.x * _58.x;
  float _73 = _70.x * _62.y;
  float _74 = _70.x * _68.z;
  float4 _75 = BloomTex.Sample(Sampler_Bilinear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));
  float _79 = _72 + -0.01109160017222166f;
  float _80 = _79 + _75.x * shader_injection.bloom_strength;  // RENODX: Bloom Strength
  float _81 = _73 + -0.01109160017222166f;
  float _82 = _81 + _75.y * shader_injection.bloom_strength;
  float _83 = _74 + -0.01109160017222166f;
  float _84 = _83 + _75.z * shader_injection.bloom_strength;
  float _85 = _80 * 0.5f;
  float _86 = _82 * 0.5f;
  float _87 = _84 * 0.5f;
  float _88 = _85 + 0.03758399933576584f;
  float _89 = _86 + 0.03758399933576584f;
  float _90 = _87 + 0.03758399933576584f;
  float _91 = log2(_88);
  float _92 = log2(_89);
  float _93 = log2(_90);
  float _94 = _91 * 0.13025538623332977f;
  float _95 = _92 * 0.13025538623332977f;
  float _96 = _93 * 0.13025538623332977f;
  float _97 = _94 + 0.6465960144996643f;
  float _98 = _95 + 0.6465960144996643f;
  float _99 = _96 + 0.6465960144996643f;
  float _100 = max(_97, 0.0f);
  float _101 = max(_98, 0.0f);
  float _102 = max(_99, 0.0f);
  float _103 = min(_100, 1.0f);
  float _104 = min(_101, 1.0f);
  float _105 = min(_102, 1.0f);
  float _106 = _105 * 31.0f;
  float _107 = floor(_106);
  float _108 = _103 * 0.030273420736193657f;
  float _109 = _104 * 0.96875f;
  float _110 = _108 + 0.0004882809880655259f;
  float _111 = _107 * 0.03125f;
  float _112 = _110 + _111;
  float _113 = 0.984375f - _109;
  float _114 = _106 - _107;
  float _115 = _112 + 0.03125f;
  float4 _116 = ColorGradingLut.Sample(Sampler_Bilinear_Clamp, float2(_115, _113));
  float4 _120 = ColorGradingLut.Sample(Sampler_Bilinear_Clamp, float2(_112, _113));
  float _124 = _116.x - _120.x;
  float _125 = _116.y - _120.y;
  float _126 = _116.z - _120.z;
  float _127 = _124 * _114;
  float _128 = _125 * _114;
  float _129 = _126 * _114;
  float _130 = _127 + _120.x;
  float _131 = _128 + _120.y;
  float _132 = _129 + _120.z;
  float _138 = _130 * Tint.x;
  float _139 = _131 * Tint.y;
  float _140 = _132 * Tint.z;
  float _143 = _138 * 0.21250000596046448f;
  float _144 = _139 * 0.715399980545044f;
  float _145 = _143 + _144;
  float _146 = _140 * 0.07209999859333038f;
  float _147 = _145 + _146;
  float _148 = _147 - _138;
  float _149 = _147 - _139;
  float _150 = _147 - _140;
  float _151 = _147 - Tint.w;
  float _152 = _148 * GrayScale;
  float _153 = _149 * GrayScale;
  float _154 = _150 * GrayScale;
  float _155 = _151 * GrayScale;
  float _156 = _152 + _138;
  float _157 = _153 + _139;
  float _158 = _154 + _140;
  float _159 = _155 + Tint.w;

  // ---- vanilla output (replaced below by renodx tone mapping) ----
  // float _162 = BrightnessFactor * 0.7999999523162842f;
  // float _163 = _162 + 1.7999999523162842f;
  // float _164 = 1.0f / _163;
  // float _165 = 1.0f - _156;
  // float _166 = 1.0f - _157;
  // float _167 = 1.0f - _158;
  // float _169 = MinBrightness * 0.03999999910593033f;
  // float _170 = _169 + -0.019999999552965164f;
  // float _171 = _165 * _170;
  // float _172 = _166 * _170;
  // float _173 = _167 * _170;
  // float _174 = _171 + _156;
  // float _175 = _172 + _157;
  // float _176 = _173 + _158;
  // float _177 = max(_174, 0.0f);
  // float _178 = max(_175, 0.0f);
  // float _179 = max(_176, 0.0f);
  // float _181 = MaxBrightness * 0.20000004768371582f;
  // float _182 = _181 + 0.8999999761581421f;
  // float _183 = _182 * _177;
  // float _184 = _182 * _178;
  // float _185 = _182 * _179;
  // float _186 = log2(_183);
  // float _187 = log2(_184);
  // float _188 = log2(_185);
  // float _189 = _186 * _164;
  // float _190 = _187 * _164;
  // float _191 = _188 * _164;
  // float _192 = exp2(_189);
  // float _193 = exp2(_190);
  // float _194 = exp2(_191);

  // RENODX: HDR tone mapping. untonemapped = scene*exposure + bloom (pre log-shaper, with the
  // 0.0110916 black floor added back); graded = post-LUT/Tint/GrayScale. Plain RGB, no swizzle.
  float3 renodx_untonemapped = float3(_72, _73, _74) + (_75.xyz * shader_injection.bloom_strength);
  float3 renodx_graded = float3(_156, _157, _158);
  float3 renodx_hdr = renodx::draw::RenderIntermediatePass(renodx::draw::ToneMapPass(renodx_untonemapped, renodx_graded));

  SV_Target.x = renodx_hdr.x;
  SV_Target.y = renodx_hdr.y;
  SV_Target.z = renodx_hdr.z;
  SV_Target.w = _159;
  return SV_Target;
}

// Once Human (sm6 / DX12) - tonemap + color-grade pass (menu / inventory).
// RenoDX HDR injection. The body is the verbatim DXC decompile of the game pass; the only edits
// are the effect-strength sliders (multiplied in at each effect source below) and the final
// display-gamma encode, which is replaced with renodx tone mapping (see end of main).
#include "./shared.h"

Texture2D<float4> AutoExposureTex : register(t0);

Texture2D<float4> BloomTex : register(t1);

Texture2D<float4> ColorGradingLut : register(t2);

Texture2D<float4> BgTex : register(t3);

cbuffer _Globals : register(b0) {
  float4 Tint : packoffset(c000.x);
  float GrayScale : packoffset(c001.x);
  float VignetteIntensity : packoffset(c001.y);
  float ChromaticAberrationRange : packoffset(c001.z);
  float ChromaticAberrationIntensity : packoffset(c001.w);
  float BrightnessFactor : packoffset(c002.x);
};

cbuffer PerScene : register(b1) {
  float VolumeWeight : packoffset(c000.x);
  int LocalFogShapeType : packoffset(c000.y);
  float4 LocalFogPackedParams[4] : packoffset(c001.x);
  int BlendWithFog : packoffset(c005.x);
  float4 ScreenSize : packoffset(c006.x);
  float FrameTime : packoffset(c007.x);
  float FrameTimeIndex : packoffset(c007.y);
  float FrameDeltaTime : packoffset(c007.z);
  float4 FrameID : packoffset(c008.x);
  float4 SkyLightColor : packoffset(c009.x);
  float SkyReflectionIntensity : packoffset(c010.x);
  float SceneEmissiveAdaption : packoffset(c010.y);
  float4 VolumetricFogParamsArray[5] : packoffset(c011.x);
  int WeatherSystem_Active : packoffset(c016.x);
  float4 WeatherSystem_Param[7] : packoffset(c017.x);
  float4 WildShadowMapParams[2] : packoffset(c024.x);
  float4 VerticalOcclusionCam[2] : packoffset(c026.x);
  float4 ReflectionProbeInfo : packoffset(c028.x);
  float4 LocalReflectionProbeInfo[3] : packoffset(c029.x);
  float4 LightProbeSH[7] : packoffset(c032.x);
  float4 LocalProbeSH[7] : packoffset(c039.x);
  float4 DayNightFade : packoffset(c046.x);
  float4 DayNightCustom : packoffset(c047.x);
  float4 SkyIlluminance : packoffset(c048.x);
  float4 RainColorRatio : packoffset(c049.x);
};

SamplerState Sampler_Bilinear_Clamp : register(s0);

float4 main(
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float _10 = TEXCOORD.x * 2.0f;
  float _11 = TEXCOORD.y * 2.0f;
  float _12 = _10 + -1.0f;
  float _13 = _11 + -1.0f;
  float _14 = abs(_12);
  float _15 = abs(_13);
  float _18 = 1.0f - ChromaticAberrationRange;
  float _19 = max(_18, 0.0f);
  float _20 = min(_19, 1.0f);
  float _21 = 1.0f - _20;
  float _22 = _14 - _20;
  float _23 = _15 - _20;
  float _24 = _22 / _21;
  float _25 = _23 / _21;
  float _26 = saturate(_24);
  float _27 = saturate(_25);
  float _28 = _26 * 2.0f;
  float _29 = _27 * 2.0f;
  float _30 = 3.0f - _28;
  float _31 = 3.0f - _29;
  float _32 = TEXCOORD.x + -0.5f;
  float _33 = TEXCOORD.y + -0.5f;
  bool _34 = (_32 > 0.0f);
  bool _35 = (_33 > 0.0f);
  bool _36 = (_32 < 0.0f);
  bool _37 = (_33 < 0.0f);
  int _38 = (int)(uint)(_34);
  int _39 = (int)(uint)(_35);
  int _40 = (int)(uint)(_36);
  int _41 = (int)(uint)(_37);
  int _42 = _38 - _40;
  int _43 = _39 - _41;
  float _44 = float((int)(_42));
  float _45 = float((int)(_43));
  float _47 = _44 * 0.029999999329447746f;
  float _48 = _26 * _26;
  float _49 = _48 * _47;
  float _50 = _49 * _30;
  float _51 = _50 * (ChromaticAberrationIntensity * shader_injection.chromatic_aberration_strength);  // RENODX: chromatic aberration strength
  float _52 = _45 * 0.029999999329447746f;
  float _53 = _27 * _27;
  float _54 = _53 * _52;
  float _55 = _54 * _31;
  float _56 = _55 * (ChromaticAberrationIntensity * shader_injection.chromatic_aberration_strength);
  float _57 = _51 * 0.33333298563957214f;
  float _58 = _56 * 0.33333298563957214f;
  float4 _59 = BgTex.Sample(Sampler_Bilinear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));
  float _61 = TEXCOORD.x - _57;
  float _62 = TEXCOORD.y - _58;
  float4 _63 = BgTex.Sample(Sampler_Bilinear_Clamp, float2(_61, _62));
  float _65 = _51 * 0.6666659712791443f;
  float _66 = _56 * 0.6666659712791443f;
  float _67 = TEXCOORD.x - _65;
  float _68 = TEXCOORD.y - _66;
  float4 _69 = BgTex.Sample(Sampler_Bilinear_Clamp, float2(_67, _68));
  float _71 = -0.0f - _13;
  float _72 = max(_71, 0.0f);
  float _73 = min(_72, 1.0f);
  float _76 = (VignetteIntensity * shader_injection.vignette_strength) * _12;  // RENODX: vignette strength
  float _77 = (VignetteIntensity * shader_injection.vignette_strength) * _71;
  float _78 = dot(float2(_76, _77), float2(_76, _77));
  float _79 = _78 + 1.0f;
  float _80 = 1.0f / _79;
  float _81 = _80 * _80;
  float _84 = 1.0f - VolumeWeight;
  float _87 = min(DayNightFade.w, _84);
  float _88 = min(_87, 1.0f);
  float _89 = _73 * _73;
  float _90 = _89 * _88;
  float _91 = 1.0f - _90;
  float _92 = _81 * _91;
  float _93 = _92 * _59.x;
  float _94 = _92 * _63.y;
  float _95 = _92 * _69.z;
  float4 _96 = AutoExposureTex.Sample(Sampler_Bilinear_Clamp, float2(0.5f, 0.5f));
  float _98 = _93 * _96.x;
  float _99 = _94 * _96.x;
  float _100 = _95 * _96.x;
  float4 _101 = BloomTex.Sample(Sampler_Bilinear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));
  float _105 = _98 + -0.01109160017222166f;
  float _106 = _105 + _101.x * shader_injection.bloom_strength;  // RENODX: bloom strength
  float _107 = _99 + -0.01109160017222166f;
  float _108 = _107 + _101.y * shader_injection.bloom_strength;
  float _109 = _100 + -0.01109160017222166f;
  float _110 = _109 + _101.z * shader_injection.bloom_strength;
  float _111 = _106 * 0.5f;
  float _112 = _108 * 0.5f;
  float _113 = _110 * 0.5f;
  float _114 = _111 + 0.03758399933576584f;
  float _115 = _112 + 0.03758399933576584f;
  float _116 = _113 + 0.03758399933576584f;
  float _117 = log2(_114);
  float _118 = log2(_115);
  float _119 = log2(_116);
  float _120 = _117 * 0.13025538623332977f;
  float _121 = _118 * 0.13025538623332977f;
  float _122 = _119 * 0.13025538623332977f;
  float _123 = _120 + 0.6465960144996643f;
  float _124 = _121 + 0.6465960144996643f;
  float _125 = _122 + 0.6465960144996643f;
  float _126 = max(_123, 0.0f);
  float _127 = max(_124, 0.0f);
  float _128 = max(_125, 0.0f);
  float _129 = min(_126, 1.0f);
  float _130 = min(_127, 1.0f);
  float _131 = min(_128, 1.0f);
  float _132 = _131 * 31.0f;
  float _133 = floor(_132);
  float _134 = _129 * 0.030273420736193657f;
  float _135 = _130 * 0.96875f;
  float _136 = _134 + 0.0004882809880655259f;
  float _137 = _133 * 0.03125f;
  float _138 = _136 + _137;
  float _139 = 0.984375f - _135;
  float _140 = _132 - _133;
  float _141 = _138 + 0.03125f;
  float4 _142 = ColorGradingLut.Sample(Sampler_Bilinear_Clamp, float2(_141, _139));
  float4 _146 = ColorGradingLut.Sample(Sampler_Bilinear_Clamp, float2(_138, _139));
  float _150 = _142.x - _146.x;
  float _151 = _142.y - _146.y;
  float _152 = _142.z - _146.z;
  float _153 = _150 * _140;
  float _154 = _151 * _140;
  float _155 = _152 * _140;
  float _156 = _153 + _146.x;
  float _157 = _154 + _146.y;
  float _158 = _155 + _146.z;
  float _164 = _156 * Tint.x;
  float _165 = _157 * Tint.y;
  float _166 = _158 * Tint.z;
  float _169 = _164 * 0.21250000596046448f;
  float _170 = _165 * 0.715399980545044f;
  float _171 = _169 + _170;
  float _172 = _166 * 0.07209999859333038f;
  float _173 = _171 + _172;
  float _174 = _173 - _164;
  float _175 = _173 - _165;
  float _176 = _173 - _166;
  float _177 = _173 - Tint.w;
  float _178 = _174 * GrayScale;
  float _179 = _175 * GrayScale;
  float _180 = _176 * GrayScale;
  float _181 = _177 * GrayScale;
  float _182 = _178 + _164;
  float _183 = _179 + _165;
  float _184 = _180 + _166;
  float _185 = _181 + Tint.w;
  // ---- vanilla output (replaced below by renodx tone mapping) ----
  // float gamma = 1.0 / (BrightnessFactor * 0.8 + 1.8);
  // SV_Target.xyz = exp2(log2(graded) * gamma);  // per-channel display-gamma encode
  // RENODX: HDR tone mapping. untonemapped = scene*exposure + bloom (pre log-shaper, with the
  // 0.0110916 black floor added back); graded = post-LUT/Tint/GrayScale. Plain RGB, no swizzle.
  float3 renodx_untonemapped = float3(_106, _108, _110) + 0.01109160017222166f;
  float3 renodx_graded = float3(_182, _183, _184);
  float3 renodx_hdr = renodx::draw::RenderIntermediatePass(renodx::draw::ToneMapPass(renodx_untonemapped, renodx_graded));
  SV_Target.x = renodx_hdr.x;
  SV_Target.y = renodx_hdr.y;
  SV_Target.z = renodx_hdr.z;
  SV_Target.w = _185;
  return SV_Target;
}

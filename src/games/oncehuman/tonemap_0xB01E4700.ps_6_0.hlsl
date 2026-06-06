// Once Human (sm6 / DX12) - tonemap + color-grade pass (gameplay variant).
// RenoDX HDR injection. The body is the verbatim DXC decompile of the game pass; the only edits
// are the effect-strength sliders (multiplied in at each effect source below) and the final
// display-gamma encode, which is replaced with renodx tone mapping (see end of main).
#include "./shared.h"

Texture2D<float4> SDFCheckerBuffer : register(t0);

Texture2D<float4> AutoExposureTex : register(t1);

Texture2D<float4> BloomTex : register(t2);

Texture2D<float4> ColorGradingLut : register(t3);

Texture2D<float4> BgTex : register(t4);

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

SamplerState Sampler_Point_Clamp : register(s1);

float4 main(
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float _12 = TEXCOORD.x * 2.0f;
  float _13 = TEXCOORD.y * 2.0f;
  float _14 = _12 + -1.0f;
  float _15 = _13 + -1.0f;
  float _16 = abs(_14);
  float _17 = abs(_15);
  float _20 = 1.0f - ChromaticAberrationRange;
  float _21 = max(_20, 0.0f);
  float _22 = min(_21, 1.0f);
  float _23 = 1.0f - _22;
  float _24 = _16 - _22;
  float _25 = _17 - _22;
  float _26 = _24 / _23;
  float _27 = _25 / _23;
  float _28 = saturate(_26);
  float _29 = saturate(_27);
  float _30 = _28 * 2.0f;
  float _31 = _29 * 2.0f;
  float _32 = 3.0f - _30;
  float _33 = 3.0f - _31;
  float _34 = TEXCOORD.x + -0.5f;
  float _35 = TEXCOORD.y + -0.5f;
  bool _36 = (_34 > 0.0f);
  bool _37 = (_35 > 0.0f);
  bool _38 = (_34 < 0.0f);
  bool _39 = (_35 < 0.0f);
  int _40 = (int)(uint)(_36);
  int _41 = (int)(uint)(_37);
  int _42 = (int)(uint)(_38);
  int _43 = (int)(uint)(_39);
  int _44 = _40 - _42;
  int _45 = _41 - _43;
  float _46 = float((int)(_44));
  float _47 = float((int)(_45));
  float _49 = _46 * 0.029999999329447746f;
  float _50 = _28 * _28;
  float _51 = _50 * _49;
  float _52 = _51 * _32;
  float _53 = _52 * (ChromaticAberrationIntensity * shader_injection.chromatic_aberration_strength);  // RENODX: chromatic aberration strength
  float _54 = _47 * 0.029999999329447746f;
  float _55 = _29 * _29;
  float _56 = _55 * _54;
  float _57 = _56 * _33;
  float _58 = _57 * (ChromaticAberrationIntensity * shader_injection.chromatic_aberration_strength);
  float _59 = _53 * 0.33333298563957214f;
  float _60 = _58 * 0.33333298563957214f;
  float4 _61 = BgTex.Sample(Sampler_Bilinear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));
  float _63 = TEXCOORD.x - _59;
  float _64 = TEXCOORD.y - _60;
  float4 _65 = BgTex.Sample(Sampler_Bilinear_Clamp, float2(_63, _64));
  float _67 = _53 * 0.6666659712791443f;
  float _68 = _58 * 0.6666659712791443f;
  float _69 = TEXCOORD.x - _67;
  float _70 = TEXCOORD.y - _68;
  float4 _71 = BgTex.Sample(Sampler_Bilinear_Clamp, float2(_69, _70));
  float _73 = -0.0f - _15;
  float _74 = max(_73, 0.0f);
  float _75 = min(_74, 1.0f);
  float _78 = (VignetteIntensity * shader_injection.vignette_strength) * _14;  // RENODX: vignette strength
  float _79 = (VignetteIntensity * shader_injection.vignette_strength) * _73;
  float _80 = dot(float2(_78, _79), float2(_78, _79));
  float _81 = _80 + 1.0f;
  float _82 = 1.0f / _81;
  float4 _83 = BloomTex.Sample(Sampler_Bilinear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));
  float _87 = _82 * _82;
  float4 _88 = SDFCheckerBuffer.SampleLevel(Sampler_Point_Clamp, float2(0.5f, 0.5f), 0.0f);
  float _92 = 1.0f - VolumeWeight;
  float _95 = min(DayNightFade.w, _92);
  float _96 = min(_95, _88.w);
  float _97 = _75 * _75;
  float _98 = _97 * _96;
  float _99 = 1.0f - _98;
  float _100 = _87 * _99;
  float _101 = _100 * _61.x;
  float _102 = _100 * _65.y;
  float _103 = _100 * _71.z;
  float4 _104 = AutoExposureTex.Sample(Sampler_Bilinear_Clamp, float2(0.5f, 0.5f));
  float _106 = _101 * _104.x;
  float _107 = _102 * _104.x;
  float _108 = _103 * _104.x;
  float _109 = _88.w * 0.8999999761581421f;
  float _110 = _109 + 0.10000000149011612f;
  float _111 = _110 * _83.x * shader_injection.bloom_strength;  // RENODX: bloom strength
  float _112 = _106 + -0.01109160017222166f;
  float _113 = _112 + _111;
  float _114 = _110 * _83.y * shader_injection.bloom_strength;
  float _115 = _107 + -0.01109160017222166f;
  float _116 = _115 + _114;
  float _117 = _110 * _83.z * shader_injection.bloom_strength;
  float _118 = _108 + -0.01109160017222166f;
  float _119 = _118 + _117;
  float _120 = _113 * 0.5f;
  float _121 = _116 * 0.5f;
  float _122 = _119 * 0.5f;
  float _123 = _120 + 0.03758399933576584f;
  float _124 = _121 + 0.03758399933576584f;
  float _125 = _122 + 0.03758399933576584f;
  float _126 = log2(_123);
  float _127 = log2(_124);
  float _128 = log2(_125);
  float _129 = _126 * 0.13025538623332977f;
  float _130 = _127 * 0.13025538623332977f;
  float _131 = _128 * 0.13025538623332977f;
  float _132 = _129 + 0.6465960144996643f;
  float _133 = _130 + 0.6465960144996643f;
  float _134 = _131 + 0.6465960144996643f;
  float _135 = max(_132, 0.0f);
  float _136 = max(_133, 0.0f);
  float _137 = max(_134, 0.0f);
  float _138 = min(_135, 1.0f);
  float _139 = min(_136, 1.0f);
  float _140 = min(_137, 1.0f);
  float _141 = _140 * 31.0f;
  float _142 = floor(_141);
  float _143 = _138 * 0.030273420736193657f;
  float _144 = _139 * 0.96875f;
  float _145 = _143 + 0.0004882809880655259f;
  float _146 = _142 * 0.03125f;
  float _147 = _145 + _146;
  float _148 = 0.984375f - _144;
  float _149 = _141 - _142;
  float _150 = _147 + 0.03125f;
  float4 _151 = ColorGradingLut.Sample(Sampler_Bilinear_Clamp, float2(_150, _148));
  float4 _155 = ColorGradingLut.Sample(Sampler_Bilinear_Clamp, float2(_147, _148));
  float _159 = _151.x - _155.x;
  float _160 = _151.y - _155.y;
  float _161 = _151.z - _155.z;
  float _162 = _159 * _149;
  float _163 = _160 * _149;
  float _164 = _161 * _149;
  float _165 = _162 + _155.x;
  float _166 = _163 + _155.y;
  float _167 = _164 + _155.z;
  float _173 = _165 * Tint.x;
  float _174 = _166 * Tint.y;
  float _175 = _167 * Tint.z;
  float _178 = _173 * 0.21250000596046448f;
  float _179 = _174 * 0.715399980545044f;
  float _180 = _178 + _179;
  float _181 = _175 * 0.07209999859333038f;
  float _182 = _180 + _181;
  float _183 = _182 - _173;
  float _184 = _182 - _174;
  float _185 = _182 - _175;
  float _186 = _182 - Tint.w;
  float _187 = _183 * GrayScale;
  float _188 = _184 * GrayScale;
  float _189 = _185 * GrayScale;
  float _190 = _186 * GrayScale;
  float _191 = _187 + _173;
  float _192 = _188 + _174;
  float _193 = _189 + _175;
  float _194 = _190 + Tint.w;
  // ---- vanilla output (replaced below by renodx tone mapping) ----
  // float gamma = 1.0 / (BrightnessFactor * 0.8 + 1.8);
  // SV_Target.xyz = exp2(log2(graded) * gamma);  // per-channel display-gamma encode
  // RENODX: HDR tone mapping. untonemapped = scene*exposure + bloom (pre log-shaper, with the
  // 0.0110916 black floor added back); graded = post-LUT/Tint/GrayScale. Plain RGB, no swizzle.
  float3 renodx_untonemapped = float3(_113, _116, _119) + 0.01109160017222166f;
  float3 renodx_graded = float3(_191, _192, _193);
  float3 renodx_hdr = renodx::draw::RenderIntermediatePass(renodx::draw::ToneMapPass(renodx_untonemapped, renodx_graded));
  SV_Target.x = renodx_hdr.x;
  SV_Target.y = renodx_hdr.y;
  SV_Target.z = renodx_hdr.z;
  SV_Target.w = _194;
  return SV_Target;
}

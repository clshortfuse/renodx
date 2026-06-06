// Once Human (sm6 / DX12) - tonemap + color-grade pass (menu / inventory variant).
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
  float BrightnessFactor : packoffset(c001.z);
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
  float4 _10 = BgTex.Sample(Sampler_Bilinear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));
  float _15 = TEXCOORD.x * 2.0f;
  float _16 = TEXCOORD.y * 2.0f;
  float _17 = _15 + -1.0f;
  float _18 = _16 + -1.0f;
  float _19 = -0.0f - _18;
  float _20 = max(_19, 0.0f);
  float _21 = min(_20, 1.0f);
  float _24 = (VignetteIntensity * shader_injection.vignette_strength) * _17;  // RENODX: vignette strength
  float _25 = (VignetteIntensity * shader_injection.vignette_strength) * _19;
  float _26 = dot(float2(_24, _25), float2(_24, _25));
  float _27 = _26 + 1.0f;
  float _28 = 1.0f / _27;
  float _29 = _28 * _28;
  float _32 = 1.0f - VolumeWeight;
  float _35 = min(DayNightFade.w, _32);
  float _36 = min(_35, 1.0f);
  float _37 = _21 * _21;
  float _38 = _37 * _36;
  float _39 = 1.0f - _38;
  float _40 = _29 * _39;
  float _41 = _40 * _10.x;
  float _42 = _40 * _10.y;
  float _43 = _40 * _10.z;
  float4 _44 = AutoExposureTex.Sample(Sampler_Bilinear_Clamp, float2(0.5f, 0.5f));
  float _46 = _41 * _44.x;
  float _47 = _42 * _44.x;
  float _48 = _43 * _44.x;
  float4 _49 = BloomTex.Sample(Sampler_Bilinear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));
  float _53 = _46 + -0.01109160017222166f;
  float _54 = _53 + _49.x * shader_injection.bloom_strength;  // RENODX: bloom strength
  float _55 = _47 + -0.01109160017222166f;
  float _56 = _55 + _49.y * shader_injection.bloom_strength;
  float _57 = _48 + -0.01109160017222166f;
  float _58 = _57 + _49.z * shader_injection.bloom_strength;
  float _59 = _54 * 0.5f;
  float _60 = _56 * 0.5f;
  float _61 = _58 * 0.5f;
  float _62 = _59 + 0.03758399933576584f;
  float _63 = _60 + 0.03758399933576584f;
  float _64 = _61 + 0.03758399933576584f;
  float _65 = log2(_62);
  float _66 = log2(_63);
  float _67 = log2(_64);
  float _68 = _65 * 0.13025538623332977f;
  float _69 = _66 * 0.13025538623332977f;
  float _70 = _67 * 0.13025538623332977f;
  float _71 = _68 + 0.6465960144996643f;
  float _72 = _69 + 0.6465960144996643f;
  float _73 = _70 + 0.6465960144996643f;
  float _74 = max(_71, 0.0f);
  float _75 = max(_72, 0.0f);
  float _76 = max(_73, 0.0f);
  float _77 = min(_74, 1.0f);
  float _78 = min(_75, 1.0f);
  float _79 = min(_76, 1.0f);
  float _80 = _79 * 31.0f;
  float _81 = floor(_80);
  float _82 = _77 * 0.030273420736193657f;
  float _83 = _78 * 0.96875f;
  float _84 = _82 + 0.0004882809880655259f;
  float _85 = _81 * 0.03125f;
  float _86 = _84 + _85;
  float _87 = 0.984375f - _83;
  float _88 = _80 - _81;
  float _89 = _86 + 0.03125f;
  float4 _90 = ColorGradingLut.Sample(Sampler_Bilinear_Clamp, float2(_89, _87));
  float4 _94 = ColorGradingLut.Sample(Sampler_Bilinear_Clamp, float2(_86, _87));
  float _98 = _90.x - _94.x;
  float _99 = _90.y - _94.y;
  float _100 = _90.z - _94.z;
  float _101 = _98 * _88;
  float _102 = _99 * _88;
  float _103 = _100 * _88;
  float _104 = _101 + _94.x;
  float _105 = _102 + _94.y;
  float _106 = _103 + _94.z;
  float _112 = _104 * Tint.x;
  float _113 = _105 * Tint.y;
  float _114 = _106 * Tint.z;
  float _115 = Tint.w * _10.w;
  float _118 = _112 * 0.21250000596046448f;
  float _119 = _113 * 0.715399980545044f;
  float _120 = _118 + _119;
  float _121 = _114 * 0.07209999859333038f;
  float _122 = _120 + _121;
  float _123 = _122 - _112;
  float _124 = _122 - _113;
  float _125 = _122 - _114;
  float _126 = _122 - _115;
  float _127 = _123 * GrayScale;
  float _128 = _124 * GrayScale;
  float _129 = _125 * GrayScale;
  float _130 = _126 * GrayScale;
  float _131 = _127 + _112;
  float _132 = _128 + _113;
  float _133 = _129 + _114;
  float _134 = _130 + _115;
  // ---- vanilla output (replaced below by renodx tone mapping) ----
  // float gamma = 1.0 / (BrightnessFactor * 0.8 + 1.8);
  // SV_Target.xyz = exp2(log2(graded) * gamma);  // per-channel display-gamma encode
  // RENODX: HDR tone mapping. untonemapped = scene*exposure + bloom (pre log-shaper, with the
  // 0.0110916 black floor added back); graded = post-LUT/Tint/GrayScale. Plain RGB, no swizzle.
  float3 renodx_untonemapped = float3(_54, _56, _58) + 0.01109160017222166f;
  float3 renodx_graded = float3(_131, _132, _133);
  float3 renodx_hdr = renodx::draw::RenderIntermediatePass(renodx::draw::ToneMapPass(renodx_untonemapped, renodx_graded));
  SV_Target.x = renodx_hdr.x;
  SV_Target.y = renodx_hdr.y;
  SV_Target.z = renodx_hdr.z;
  SV_Target.w = _134;
  return SV_Target;
}

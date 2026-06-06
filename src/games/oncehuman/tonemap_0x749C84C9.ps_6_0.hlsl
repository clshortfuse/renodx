// Once Human (sm6 / DX12) - tonemap + color-grade pass (gameplay).
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

SamplerState Sampler_Point_Clamp : register(s1);

float4 main(
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float4 _12 = BgTex.Sample(Sampler_Bilinear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));
  float _17 = TEXCOORD.x * 2.0f;
  float _18 = TEXCOORD.y * 2.0f;
  float _19 = _17 + -1.0f;
  float _20 = _18 + -1.0f;
  float _21 = -0.0f - _20;
  float _22 = max(_21, 0.0f);
  float _23 = min(_22, 1.0f);
  float _26 = (VignetteIntensity * shader_injection.vignette_strength) * _19;  // RENODX: vignette strength
  float _27 = (VignetteIntensity * shader_injection.vignette_strength) * _21;
  float _28 = dot(float2(_26, _27), float2(_26, _27));
  float _29 = _28 + 1.0f;
  float _30 = 1.0f / _29;
  float4 _31 = BloomTex.Sample(Sampler_Bilinear_Clamp, float2(TEXCOORD.x, TEXCOORD.y));
  float _35 = _30 * _30;
  float4 _36 = SDFCheckerBuffer.SampleLevel(Sampler_Point_Clamp, float2(0.5f, 0.5f), 0.0f);
  float _40 = 1.0f - VolumeWeight;
  float _43 = min(DayNightFade.w, _40);
  float _44 = min(_43, _36.w);
  float _45 = _23 * _23;
  float _46 = _45 * _44;
  float _47 = 1.0f - _46;
  float _48 = _35 * _47;
  float _49 = _48 * _12.x;
  float _50 = _48 * _12.y;
  float _51 = _48 * _12.z;
  float4 _52 = AutoExposureTex.Sample(Sampler_Bilinear_Clamp, float2(0.5f, 0.5f));
  float _54 = _49 * _52.x;
  float _55 = _50 * _52.x;
  float _56 = _51 * _52.x;
  float _57 = _36.w * 0.8999999761581421f;
  float _58 = _57 + 0.10000000149011612f;
  float _59 = _58 * _31.x * shader_injection.bloom_strength;  // RENODX: bloom strength
  float _60 = _54 + -0.01109160017222166f;
  float _61 = _60 + _59;
  float _62 = _58 * _31.y * shader_injection.bloom_strength;
  float _63 = _55 + -0.01109160017222166f;
  float _64 = _63 + _62;
  float _65 = _58 * _31.z * shader_injection.bloom_strength;
  float _66 = _56 + -0.01109160017222166f;
  float _67 = _66 + _65;
  float _68 = _61 * 0.5f;
  float _69 = _64 * 0.5f;
  float _70 = _67 * 0.5f;
  float _71 = _68 + 0.03758399933576584f;
  float _72 = _69 + 0.03758399933576584f;
  float _73 = _70 + 0.03758399933576584f;
  float _74 = log2(_71);
  float _75 = log2(_72);
  float _76 = log2(_73);
  float _77 = _74 * 0.13025538623332977f;
  float _78 = _75 * 0.13025538623332977f;
  float _79 = _76 * 0.13025538623332977f;
  float _80 = _77 + 0.6465960144996643f;
  float _81 = _78 + 0.6465960144996643f;
  float _82 = _79 + 0.6465960144996643f;
  float _83 = max(_80, 0.0f);
  float _84 = max(_81, 0.0f);
  float _85 = max(_82, 0.0f);
  float _86 = min(_83, 1.0f);
  float _87 = min(_84, 1.0f);
  float _88 = min(_85, 1.0f);
  float _89 = _88 * 31.0f;
  float _90 = floor(_89);
  float _91 = _86 * 0.030273420736193657f;
  float _92 = _87 * 0.96875f;
  float _93 = _91 + 0.0004882809880655259f;
  float _94 = _90 * 0.03125f;
  float _95 = _93 + _94;
  float _96 = 0.984375f - _92;
  float _97 = _89 - _90;
  float _98 = _95 + 0.03125f;
  float4 _99 = ColorGradingLut.Sample(Sampler_Bilinear_Clamp, float2(_98, _96));
  float4 _103 = ColorGradingLut.Sample(Sampler_Bilinear_Clamp, float2(_95, _96));
  float _107 = _99.x - _103.x;
  float _108 = _99.y - _103.y;
  float _109 = _99.z - _103.z;
  float _110 = _107 * _97;
  float _111 = _108 * _97;
  float _112 = _109 * _97;
  float _113 = _110 + _103.x;
  float _114 = _111 + _103.y;
  float _115 = _112 + _103.z;
  float _121 = _113 * Tint.x;
  float _122 = _114 * Tint.y;
  float _123 = _115 * Tint.z;
  float _124 = Tint.w * _12.w;
  float _127 = _121 * 0.21250000596046448f;
  float _128 = _122 * 0.715399980545044f;
  float _129 = _127 + _128;
  float _130 = _123 * 0.07209999859333038f;
  float _131 = _129 + _130;
  float _132 = _131 - _121;
  float _133 = _131 - _122;
  float _134 = _131 - _123;
  float _135 = _131 - _124;
  float _136 = _132 * GrayScale;
  float _137 = _133 * GrayScale;
  float _138 = _134 * GrayScale;
  float _139 = _135 * GrayScale;
  float _140 = _136 + _121;
  float _141 = _137 + _122;
  float _142 = _138 + _123;
  float _143 = _139 + _124;
  // ---- vanilla output (replaced below by renodx tone mapping) ----
  // float gamma = 1.0 / (BrightnessFactor * 0.8 + 1.8);
  // SV_Target.xyz = exp2(log2(graded) * gamma);  // per-channel display-gamma encode
  // RENODX: HDR tone mapping. untonemapped = scene*exposure + bloom (pre log-shaper, with the
  // 0.0110916 black floor added back); graded = post-LUT/Tint/GrayScale. Plain RGB, no swizzle.
  float3 renodx_untonemapped = float3(_61, _64, _67) + 0.01109160017222166f;
  float3 renodx_graded = float3(_140, _141, _142);
  float3 renodx_hdr = renodx::draw::RenderIntermediatePass(renodx::draw::ToneMapPass(renodx_untonemapped, renodx_graded));
  SV_Target.x = renodx_hdr.x;
  SV_Target.y = renodx_hdr.y;
  SV_Target.z = renodx_hdr.z;
  SV_Target.w = _143;
  return SV_Target;
}

#include "./common.hlsl"
#include "./include/CBuffer_Globals.hlsl"
#include "./include/CBuffer_View.hlsl"
#include "./include/Registers.hlsl"

SamplerState View_SharedBilinearClampedSampler : register(s0);

void BlendOverlay(inout float4 background, float3 tonemapped_bt2020, float4 TEXCOORD_1) {
  float3 normalizedTonemapped_bt2020 = tonemapped_bt2020 * (10000.f / RENODX_DIFFUSE_WHITE_NITS) * 10000.f;

  // Clamp RGB to avoid division by zero
  float epsilon = 9.999999747378752e-05f;
  float3 overlayColor_bt2020 = max(HDRCompositionContextColor.xyz, epsilon);  // In bt2020

  // Luminance of HDR color and a reference white‐scale factor
  float3 lumWeights = float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f);  // Vanilla used bt709 coefficients

  float invLuma = 1.0f / dot(overlayColor_bt2020, lumWeights);
  float whiteScale = invLuma * (dot(normalizedTonemapped_bt2020, lumWeights) * epsilon);  // _296
  overlayColor_bt2020 = saturate(overlayColor_bt2020 * whiteScale);
  // float3 overlayColor_bt709 = renodx::color::bt709::from::BT2020(overlayColor_bt2020);
  float3 overlayColor_bt709 = overlayColor_bt2020;

  // Calculate vignette falloff from depth/position
  float normalizedDepth = (1.0f / max(0.001f, HDRCompositionContext.z)) * TEXCOORD_1.w;
  float depthSq = normalizedDepth * normalizedDepth;
  float distanceSq = dot(float3(TEXCOORD_1.xy, normalizedDepth),
                         float3(TEXCOORD_1.xy, normalizedDepth));
  float normalizedDistance = depthSq / max(1e-6f, distanceSq);
  float vignetteFalloff = (saturate(normalizedDistance * normalizedDistance) - 1.0f) * HDRCompositionContext.y;

  // Calculate HDR overlay blend factor (negative = darkening effect)
  float overlayBlendFactor = -((HDRCompositionContext.x * vignetteFalloff) * background.a);

  // Apply HDR overlay to background
  float3 overlayedBackground;
  overlayedBackground.rgb = ((overlayColor_bt709.rgb) * overlayBlendFactor) + background.rgb;

  // Calculate background alpha with vignette
  float overlayedBackgroundAlpha = background.a * ((vignetteFalloff * HDRCompositionContext.x) + 1.0f);

  background = float4(overlayedBackground, overlayedBackgroundAlpha);
}

float getMidGray() {
  float3 lutInputColor = saturate(renodx::color::pq::Encode(0.18f, 100.f));
  float3 lutResult = renodx::lut::Sample(BT709PQToBT2020PQLUT,
                                         View_SharedBilinearClampedSampler,
                                         lutInputColor,
                                         32u);
  float3 lutOutputColor_bt2020 = renodx::color::pq::DecodeSafe(lutResult, 250);

  return renodx::color::y::from::BT2020(lutOutputColor_bt2020);
}

float4 HDRComposite(noperspective float2 TEXCOORD: TEXCOORD,
                    noperspective float4 TEXCOORD_1: TEXCOORD1,
                    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 SV_Target;
  bool _18 = !((DeviceCorrectorContext.z) == 0.0f);
  float _34 = (SV_Position.x) - (float((uint)(ViewportDestination_ViewportMin.x)));
  float _35 = (SV_Position.y) - (float((uint)(ViewportDestination_ViewportMin.y)));
  float _41 = saturate((_34 * (ViewportDestination_ViewportSizeInverse.x)));
  float _42 = saturate((_35 * (ViewportDestination_ViewportSizeInverse.y)));
  float _55 = (_18 ? (saturate(((ViewportDestination_ViewportSizeInverse.x) * (((floor((_34 * 0.5f))) * 2.0f) + 1.0f)))) : _41);
  float _56 = (_18 ? (saturate(((((floor((_35 * 0.5f))) * 2.0f) + 1.0f) * (ViewportDestination_ViewportSizeInverse.y)))) : _42);

  // // main color
  float4 _125 = ColorTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((max(((((ViewportColor_ViewportSize.x) * _55) + (float((uint)(ViewportColor_ViewportMin.x)))) * (ViewportColor_ExtentInverse.x)), (ViewportColor_UVViewportBilinearMin.x))), (ViewportColor_UVViewportBilinearMax.x))), (min((max(((((ViewportColor_ViewportSize.y) * _56) + (float((uint)(ViewportColor_ViewportMin.y)))) * (ViewportColor_ExtentInverse.y)), (ViewportColor_UVViewportBilinearMin.y))), (ViewportColor_UVViewportBilinearMax.y)))), 0.0f);

  float _137 = (1.0f / (max(0.0010000000474974513f, (VignetteContext.y)))) * (TEXCOORD_1.z);
  float _142 = (_137 * _137) * (1.0f / (max(9.999999747378752e-06f, (dot(float3((TEXCOORD_1.x), (TEXCOORD_1.y), _137), float3((TEXCOORD_1.x), (TEXCOORD_1.y), _137))))));
  float _146 = (((_142 * _142) + -1.0f) * (VignetteContext.x)) + 1.0f;
  float _147 = _146 * (min((_125.x), 65504.0f));
  float _148 = _146 * (min((_125.y), 65504.0f));
  float _149 = _146 * (min((_125.z), 65504.0f));

  float3 main_color = float3(_147, _148, _149);

  // Glare
  float2 glareUV = float2(
      min(max((((ViewportGlare_ViewportSize.x * _55) + float((uint)(int)(ViewportGlare_ViewportMin.x))) * ViewportGlare_ExtentInverse.x), ViewportGlare_UVViewportBilinearMin.x), ViewportGlare_UVViewportBilinearMax.x),
      min(max((((ViewportGlare_ViewportSize.y * _56) + float((uint)(int)(ViewportGlare_ViewportMin.y))) * ViewportGlare_ExtentInverse.y), ViewportGlare_UVViewportBilinearMin.y), ViewportGlare_UVViewportBilinearMax.y));
  float4 glareSample = GlareTexture.SampleLevel(View_SharedBilinearClampedSampler, glareUV, 0.0f);
  float3 ungraded_bt709;
#if defined(USE_STATIC)
  float _179 = saturate(ViewportColor_ViewportSize.x * 0.0002604166802484542f);
  float _180 = float((int(SV_Position.x)));
  float _182 = _180 * 0.6180340051651001f;
  float _183 = float((int(SV_Position.y))) * 0.6180340051651001f;
  float _191 = max(1.0000000116860974e-07f, frac(tan(sqrt((_183 * _183) + (_182 * _182))) * _180));
  float _194 = floor(frac(NoiseContext.w) * 59.940059661865234f);
  float _196 = (_194 * 63.13124465942383f) + _191;
  float _205 = (frac(_196) * 2.0f) + -1.0f;
  float _206 = (frac(_196 + 0.3333333432674408f) * 2.0f) + -1.0f;
  float _207 = (frac(_196 + 0.6666666865348816f) * 2.0f) + -1.0f;
  float _210 = ((_194 + 1.0f) * 63.13124465942383f) + _191;
  float _219 = (frac(_210) * 2.0f) + -1.0f;
  float _220 = (frac(_210 + 0.3333333432674408f) * 2.0f) + -1.0f;
  float _221 = (frac(_210 + 0.6666666865348816f) * 2.0f) + -1.0f;
  float _231 = select((abs(_205) > abs(_219)), _205, _219);
  float _232 = select((abs(_206) > abs(_220)), _206, _220);
  float _233 = select((abs(_207) > abs(_221)), _207, _221);
  float _234 = _179 * _179;
  float _281 = (((View_OneOverPreExposure + -1.0f) * NoiseContext.z) + 1.0f) * (View_PreExposure * NoiseContext.x);
  float _283 = (_281 * float((int)(((int)(uint)((bool)(_231 > 0.0f))) - ((int)(uint)((bool)(_231 < 0.0f)))))) * (1.0f - exp2(log2(max(0.0f, (1.0f - abs(_231)))) * _234));
  float _285 = (_281 * float((int)(((int)(uint)((bool)(_232 > 0.0f))) - ((int)(uint)((bool)(_232 < 0.0f)))))) * (1.0f - exp2(log2(max(0.0f, (1.0f - abs(_232)))) * _234));
  float _287 = (_281 * float((int)(((int)(uint)((bool)(_233 > 0.0f))) - ((int)(uint)((bool)(_233 < 0.0f)))))) * (1.0f - exp2(log2(max(0.0f, (1.0f - abs(_233)))) * _234));
  float _288 = dot(float3(_283, _285, _287), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float3 noise_rgb = float3(_283, _285, _287);
  float noise_luma = _288;

  // Glare blend + noise application
  float3 glareColor = min(glareSample.rgb, 65504.0f);
  float3 base_with_glare = ((((glareColor - main_color) + (GlareContext.y * main_color)) * GlareContext.x) + main_color);

  ungraded_bt709 = base_with_glare + noise_rgb + ((noise_luma - noise_rgb) * NoiseContext.y);
#else
  float3 glareColor = min(glareSample.xyz, 65504.0f);
  ungraded_bt709 = ((GlareContext.x * ((glareColor - main_color) + (main_color * GlareContext.y))) + main_color);
#endif

  // LUT
  float3 lutInputColor = saturate(renodx::color::pq::EncodeSafe(ungraded_bt709, 100.f));
  float3 lutResult = renodx::lut::Sample(BT709PQToBT2020PQLUT, View_SharedBilinearClampedSampler, lutInputColor, 32u);
  float3 lutOutputColor_bt2020 = renodx::color::pq::DecodeSafe(lutResult);
  float3 tonemapped = lutOutputColor_bt2020;

#if 1
  tonemapped = extractColorGradeAndApplyTonemap(ungraded_bt709, lutOutputColor_bt2020, getMidGray(), float2(_41, _42));
#endif

  float _123;
  float _124;

#if defined(USE_FMV)
  if ((!((CompositeSurfaceContext.x) == 0.0f))) {
    float _118 = min(((ViewportDestination_ViewportSize.x * 0.5625f) * ViewportDestination_ViewportSizeInverse.y), 1.0f);
    float _119 = min(((ViewportDestination_ViewportSize.y * 1.7777777910232544f) * ViewportDestination_ViewportSizeInverse.x), 1.0f);

    // linear bt709
    float3 video = CompositeSurfaceTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(((_118 * (_55 + -0.5f)) + 0.5f), ((_119 * (_56 + -0.5f)) + 0.5f)), 0.0f).rgb;

    if (!(!((CompositeSurfaceContext.y) == 0.0f))) {
      video = renodx::color::correct::GammaSafe(video.rgb);
      video = renodx::color::bt2020::from::BT709(video);
      if (CUSTOM_HDR_VIDEOS) video = PumboAutoHDR(video, 7.5f);
      video *= RENODX_DIFFUSE_WHITE_NITS;
    }
    tonemapped.rgb = video.rgb;
  }
#endif

  // UI + sRGB -> 2.2  gamma correction
#if defined(USE_MENU)
  // when in the menu the UI includes a foreground and background texture
  _123 = ((min((((ViewportDestination_ViewportSize.x) * 0.5625f) * (ViewportDestination_ViewportSizeInverse.y)), 1.0f)) * (_41 + -0.5f)) + 0.5f;
  _124 = ((min((((ViewportDestination_ViewportSize.y) * 1.7777777910232544f) * (ViewportDestination_ViewportSizeInverse.x)), 1.0f)) * (_42 + -0.5f)) + 0.5f;
  float4 _280 = CompositeSDRBackgroundTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(_123, _124), 0.0f);
#if defined(USE_OVERLAY)
  BlendOverlay(_280, tonemapped.rgb, TEXCOORD_1);
#endif
  float4 _286 = CompositeSDRTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(_123, _124), 0.0f);
  float4 _299 = CompositeSDRForegroundTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(_123, _124), 0.0f);
  float _307 = ((_299.w) * (((_286.w) * (_280.x)) + (_286.x))) + (_299.x);
  float _308 = ((_299.w) * (((_286.w) * (_280.y)) + (_286.y))) + (_299.y);
  float _309 = ((_299.w) * (((_286.w) * (_280.z)) + (_286.z))) + (_299.z);
  float _310 = ((_286.w) * (_280.w)) * (_299.w);
  float4 UI_Texture = float4(_307, _308, _309, _310);
#else
  float4 UI_Texture = CompositeSDRTexture.SampleLevel(
      View_SharedBilinearClampedSampler,
      float2((((min((((ViewportDestination_ViewportSize.x) * 0.5625f) * (ViewportDestination_ViewportSizeInverse.y)), 1.0f)) * (_55 + -0.5f)) + 0.5f),
             (((min((((ViewportDestination_ViewportSize.y) * 1.7777777910232544f) * (ViewportDestination_ViewportSizeInverse.x)), 1.0f)) * (_56 + -0.5f)) + 0.5f)),
      0.0f);
#if defined(USE_OVERLAY)
  BlendOverlay(UI_Texture, tonemapped.rgb, TEXCOORD_1);
#endif
#endif

  float3 gammaCorrectedUI = renodx::color::correct::Gamma(max(0, UI_Texture.xyz));
  float _347 = gammaCorrectedUI.r;
  float _348 = gammaCorrectedUI.g;
  float _349 = gammaCorrectedUI.b;

  // UI Blending

  float uiAlpha = UI_Texture.w;
  float uiAlphaSq = uiAlpha * uiAlpha;  // _316

  // Reinhard stuff behind UI?
  float3 lumWeight = 1.0f / ((tonemapped.rgb) + 1.0f);

  // Adaptive blend: more squared alpha in bright areas, linear alpha in dark areas
  float3 adaptiveAlpha = lerp(lumWeight, 1.f, uiAlphaSq);

  gammaCorrectedUI *= RENODX_GRAPHICS_WHITE_NITS;
  gammaCorrectedUI = renodx::color::bt2020::from::BT709(gammaCorrectedUI);

  float3 outputColor = gammaCorrectedUI + ((tonemapped.rgb) * (uiAlpha * 10000.f) * adaptiveAlpha);
  outputColor = renodx::color::pq::Encode(outputColor, 1.f);

  if (CUSTOM_FILM_GRAIN_STRENGTH != 0) {
    return float4(outputColor, 0);
  }
  float _408 = View_SpatiotemporalBlueNoiseVolumeTexture.Load(int4((int(SV_Position.x) & 127), (int(SV_Position.y) & 127), (View_StateFrameIndex & 63), 0)).x;
  float _425 = ((1.0f - (sqrt((1.0f - (abs(_408)))))) * (float(((int(((bool)((_408 > 0.0f))))) - (int(((bool)((_408 < 0.0f))))))))) * 0.0009775171056389809f;
  SV_Target.x = (saturate(((((bool)((((abs(((outputColor.r * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_425 + outputColor.r) : outputColor.r))));
  SV_Target.y = (saturate(((((bool)((((abs(((outputColor.g * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_425 + outputColor.g) : outputColor.g))));
  SV_Target.z = (saturate(((((bool)((((abs(((outputColor.b * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_425 + outputColor.b) : outputColor.b))));
  SV_Target.w = 0.0f;

  return SV_Target;
}

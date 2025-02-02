/*
struct ToneMapCBuffer {
  struct ToneMapCB {
    float4 m_PixelScale;
    float m_GrainUvScale;
    float m_GrainStrength;
    float m_GrainRandom;
    float m_InvAspectRatio;
    float m_AcesMiddleGray;
    float m_VignetteHorzScale;
    float m_VignetteVertScale;
    float m_VignetteCenterClear;
    float m_SharpenCenter;
    float m_SharpenSide;
    float m_SharpenCorner;
    float m_HdrGamma;
    float m_IsOffscreen;
    float m_ChromAbUvScale;
    float m_ChromAbRadScale;
    float m_ChromAbRadBias;
    float2 m_VignetteOffset;
    float m_FrostedHudScale;
    float m_FrostedHudBias;
    float2 m_SrgbOverlayScale;
    float2 m_SrgbOverlayBias;
    float m_ColorFilterStrength;
    float m_Contrast;
    float m_ToneMappingScale;
    float m_ApplyToneMappingScale;
    float m_HdrWhitePoint;
    float m_AspectBlurStart;
    float m_AspectBlurEnd;
    float m_AspectBlurRadius;
    float m_AspectBlurTapScale;
    float m_InvAdaptationLum;
    float m_WriteHudless;
    float m_Pad;
  } g_TM;
}
*/
cbuffer ToneMapCBufferUBO : register(b2, space0) {
  float4 ToneMapCBuffer_m0[10] : packoffset(c0);
};

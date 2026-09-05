// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 07 20:40:40 2026
//
// Assassin's Creed Rogue
// RenoDX FMV / Video HDR replacement
//
// Original behavior preserved:
// - g_Ytex  = Y video plane
// - g_cRtex = Cr video plane
// - g_cBtex = Cb video plane
// - g_Atex  = Alpha video plane
// - Original YCbCr -> RGB conversion preserved
// - Original g_AlphaLevel alpha scaling preserved
//
// RenoDX changes:
// - Applies BT.2446a inverse tonemapping only to this FMV shader.
// - Vanilla/SDR mode preserves the original video output.
// - No additional limited-range conversion is performed.
// - Video source is sanitized to 0-1 BEFORE ITM.
// - HDR values above 1.0 are preserved AFTER ITM.
// - Alpha is completely untouched by HDR processing.
//
// Target:
//   ps_5_0
//

#include "./shared.h"


cbuffer _Globals : register(b0)
{
    float4 g_AmbientCube[3] : packoffset(c0);
    float4 g_LayeredSkyUserColor : packoffset(c3);
    float4 g_LayeredSkyUserColor1 : packoffset(c4);
    float4 g_LayeredSkyUserColor2 : packoffset(c5);
    float4 g_LayeredSkyUserColor3 : packoffset(c6);
    float4 g_LayeredSkyUserColor4 : packoffset(c7);
    float4 g_CurrentTime : packoffset(c8);
    float4 g_HorizonTextureBlend : packoffset(c9);
    float4 g_SunColor : packoffset(c10);
    float4 g_SunDirection : packoffset(c11);
    float4 g_WorldLoadingRange : packoffset(c12);
    float4 g_GlobalWindPS : packoffset(c13);
    float4 g_SkySpritePosition : packoffset(c14);
    float4 g_VPOSReverseParams : packoffset(c15);
    float4 RainUVScroll : packoffset(c16);
    float4 g_RenderingReflections : packoffset(c17);
    float4 g_ViewportScaleOffset : packoffset(c18);
    float4 g_VPosToUV : packoffset(c19);
    float4 g_ReverseProjectionParams : packoffset(c20);
    float2 g_ReverseProjectionParams2 : packoffset(c21);
    float4x4 g_ViewToWorld : packoffset(c22);
    float4x4 g_WorldToView : packoffset(c26);
    float4 g_WorldEntityPosition : packoffset(c30);
    float4 g_EntityRandomSeed : packoffset(c31);
    float4 g_BoundingVolumeSize : packoffset(c32);
    float4 g_EntityToCameraDistance : packoffset(c33);
    float4 g_LODBlendFactor : packoffset(c34);
    float4 g_WeatherInfo : packoffset(c35);
    float4 g_FogWeatherParams : packoffset(c36);
    float4 g_FogParams : packoffset(c37);
    float4 g_MainPlayerPosition : packoffset(c38);
    float4 g_EyeDirection : packoffset(c39);
    float4 g_EyePosition : packoffset(c40);
    float4 g_DisolveFactor : packoffset(c41);
    float4 g_LightShaftColor : packoffset(c42);
    float4 g_LightShaftFade : packoffset(c43);
    float4 g_LightShaftFade2 : packoffset(c44);
    float4 g_EagleVisionColor : packoffset(c45);
    float4 g_EntityUniqueIDCol : packoffset(c46);
    float4 g_MaterialUniqueIDCol : packoffset(c47);
    float4 g_ShaderUniqueIDCol : packoffset(c48);
    float4 g_SelectionOverlayCol : packoffset(c49);
    float4x4 g_ConstDebugReferencePS : packoffset(c50);

    float4 g_FogColor : packoffset(c60);
    float4 g_FogSunBackColor : packoffset(c61);

    float g_AlphaTestValue : packoffset(c62);

    float4 g_NormalScale : packoffset(c63);


    struct
    {
        float4 m_PositionFar;
        float4 m_ColorFade;
    } g_OmniLights[4] : packoffset(c64);


    struct
    {
        float3 m_Direction;
        float4 m_Color;
    } g_DirectLights[2] : packoffset(c72);


    struct
    {
        float4 m_PositionFar;
        float4 m_ColorFade;
        float4 m_Direction;
        float4 m_ConeAngles;
    } g_SpotLights[2] : packoffset(c76);


    struct
    {
        float3 m_Direction;
        float4 m_Color;
        float3 m_SpecularDirection;
    } g_ShadowedDirect : packoffset(c84);


    float4 g_ProjWorldToLight[8] : packoffset(c87);

    float4 g_LightingIrradianceCoeffsR : packoffset(c95);
    float4 g_LightingIrradianceCoeffsG : packoffset(c96);
    float4 g_LightingIrradianceCoeffsB : packoffset(c97);

    float4 g_ProjShadowParams[2] : packoffset(c98);

    float g_TurnOnLights : packoffset(c201);

    float4 g_PickingID : packoffset(c124);

    float g_AlphaLevel : packoffset(c128);
}


SamplerState g_Ytex_s  : register(s0);
SamplerState g_cRtex_s : register(s1);
SamplerState g_cBtex_s : register(s2);
SamplerState g_Atex_s  : register(s3);


Texture2D<float4> g_Ytex  : register(t0);
Texture2D<float4> g_cRtex : register(t1);
Texture2D<float4> g_cBtex : register(t2);
Texture2D<float4> g_Atex  : register(t3);


// 3Dmigoto declarations
#define cmp -


// =============================================================================
// VIDEO-ONLY HDR ITM
// =============================================================================

float3 ApplyVideoITM(float3 videoColor)
{
    // -------------------------------------------------------------------------
    // VANILLA / SDR
    // -------------------------------------------------------------------------
    //
    // Keep the game's original decoded video completely unchanged.
    //

    if (RENODX_TONE_MAP_TYPE == 0.0f)
    {
        return videoColor;
    }


    // -------------------------------------------------------------------------
    // INPUT SANITIZATION
    // -------------------------------------------------------------------------
    //
    // The YCbCr matrix can naturally generate tiny negative or >1 values
    // around saturated colors.
    //
    // The actual source movie is SDR, so constrain the SOURCE to its
    // display-referred SDR range before inverse tonemapping.
    //
    // IMPORTANT:
    // This is NOT an HDR output clamp.
    //

    videoColor = saturate(videoColor);


    // -------------------------------------------------------------------------
    // RENO DX VIDEO ITM
    // -------------------------------------------------------------------------
    //
    // Current RenoDX UpscaleVideoPass expects gamma-domain video and performs:
    //
    //   gamma 2.4 decode
    //        ->
    //   BT.2446a inverse tonemapping
    //        ->
    //   normalize against HDR video peak
    //        ->
    //   Peak White / Diffuse White scaling
    //        ->
    //   gamma 2.4 encode
    //
    // Since this shader's YCbCr matrix directly outputs display/gamma-domain
    // RGB, this is the correct point to call it.
    //

    videoColor =
        renodx::draw::UpscaleVideoPass(
            videoColor
        );


    // Deliberately DO NOT saturate here.
    //
    // Values above 1.0 are the HDR highlights that we want to preserve.

    return videoColor;
}


// =============================================================================
// MAIN
// =============================================================================

void main(
    float4 v0 : SV_Position0,
    float2 v1 : TEXCOORD0,
    out float4 o0 : SV_Target0)
{
    float4 r0;

    uint4 bitmask, uiDest;
    float4 fDest;


    // =========================================================================
    // ORIGINAL ALPHA
    // =========================================================================

    r0.x =
        g_Atex.Sample(
            g_Atex_s,
            v1.xy
        ).x;


    o0.w =
        g_AlphaLevel
        * r0.x;


    // =========================================================================
    // ORIGINAL VIDEO PLANE SAMPLING
    // =========================================================================

    // Cr
    r0.y =
        g_cRtex.Sample(
            g_cRtex_s,
            v1.xy
        ).x;


    // Cb
    r0.z =
        g_cBtex.Sample(
            g_cBtex_s,
            v1.xy
        ).x;


    // Y
    r0.x =
        g_Ytex.Sample(
            g_Ytex_s,
            v1.xy
        ).x;


    // Constant used by the conversion biases.
    r0.w = 1.0f;


    // =========================================================================
    // ORIGINAL YCbCr -> RGB
    // =========================================================================
    //
    // IMPORTANT:
    //
    // These coefficients already include the limited/video-range offsets.
    //
    // In particular:
    //
    // R =
    //     1.16412354 * Y
    //   + 1.59579468 * Cr
    //   - 0.87065506
    //
    // G =
    //     1.16412354  * Y
    //   - 0.813476563 * Cr
    //   - 0.391448975 * Cb
    //   + 0.529705048
    //
    // B =
    //     1.16412354 * Y
    //   + 2.01782227 * Cb
    //   - 1.08166885
    //
    // Therefore:
    //
    // DO NOT additionally remap Y from 16-235 to 0-1.
    //
    // Doing that here would correct the black/white levels twice.
    // =========================================================================

    float3 videoColor;


    // GREEN
    videoColor.g =
        dot(
            float4(
                1.16412354f,
                -0.813476563f,
                -0.391448975f,
                0.529705048f
            ),
            r0.xyzw
        );


    // RED
    videoColor.r =
        dot(
            float3(
                1.16412354f,
                1.59579468f,
                -0.87065506f
            ),
            r0.xyw
        );


    // BLUE
    videoColor.b =
        dot(
            float3(
                1.16412354f,
                2.01782227f,
                -1.08166885f
            ),
            r0.xzw
        );


    // =========================================================================
    // RENO DX VIDEO-ONLY HDR
    // =========================================================================
    //
    // Original:
    //
    //     Y / Cr / Cb
    //          |
    //          v
    //       SDR RGB
    //          |
    //          v
    //        output
    //
    //
    // New:
    //
    //     Y / Cr / Cb
    //          |
    //          v
    //       SDR RGB
    //          |
    //          v
    //   BT.2446a video ITM
    //          |
    //          v
    //       HDR RGB
    //          |
    //          v
    //        output
    //
    // Alpha remains on the original path.
    // =========================================================================

    videoColor =
        ApplyVideoITM(
            videoColor
        );


    // =========================================================================
    // OUTPUT
    // =========================================================================
    //
    // NO final saturate().
    //
    // The output render target needs to be upgraded to a floating-point
    // format such as R16G16B16A16_FLOAT for values > 1.0 to survive.
    // =========================================================================

    o0.rgb = videoColor;

    return;
}
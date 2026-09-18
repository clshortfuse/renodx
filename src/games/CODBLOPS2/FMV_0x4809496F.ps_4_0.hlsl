// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 07 17:53:18 2026
//
// Call of Duty: Black Ops II
// RenoDX FMV / Video HDR replacement
//
// Changes:
// - Preserves the original packed video decoding.
// - Preserves both video regions.
// - Preserves scriptVector0 selection/compositing.
// - Corrects limited-range video black:
//       16/255 -> 0.0
//       235/255 -> 1.0
// - Applies that correction to LUMA before YUV -> RGB.
// - Applies RenoDX BT.2446a video ITM only after the final SDR image exists.
// - SDR mode retains the video black-level correction.
// - HDR mode additionally receives RenoDX video ITM.
// - Original opaque alpha is preserved.
//
// If the game's FMVs are actually full-range rather than limited-range,
// set VIDEO_LIMITED_RANGE to 0.
//

#include "./shared.h"


// =============================================================================
// VIDEO RANGE SETTINGS
// =============================================================================

// 1 = treat FMV luma as studio/limited range 16-235.
// 0 = leave the original luma range untouched.
#define VIDEO_LIMITED_RANGE 1


// Standard 8-bit video levels.
#define VIDEO_BLACK_LEVEL (16.0f / 255.0f)
#define VIDEO_WHITE_LEVEL (235.0f / 255.0f)


// Convert limited-range video luma:
//
//     16  -> 0
//     235 -> 1
//
// Doing this to Y before YUV -> RGB is much preferable to crushing RGB
// afterward because it restores the intended video signal itself.
float DecodeVideoLuma(float y)
{
#if VIDEO_LIMITED_RANGE
    return saturate(
        (y - VIDEO_BLACK_LEVEL)
        / (VIDEO_WHITE_LEVEL - VIDEO_BLACK_LEVEL)
    );
#else
    return y;
#endif
}


// =============================================================================
// ORIGINAL CONSTANT BUFFER
// =============================================================================

cbuffer PerObjectConsts : register(b1)
{
    float4x4 worldViewMatrix : packoffset(c0);
    float4x4 worldViewProjectionMatrix : packoffset(c4);
    float4x4 inverseTransposeWorldViewMatrix : packoffset(c8);
    float4x4 inverseWorldViewMatrix : packoffset(c12);
    float4 clipSpaceLookupScale : packoffset(c16);
    float4 clipSpaceLookupOffset : packoffset(c17);
    float4 particleCloudColor : packoffset(c18);
    float4 particleCloudMatrix : packoffset(c19);
    float4 particleCloudVelWorld : packoffset(c20);
    float4 codeMeshArg[2] : packoffset(c21);
    float4 scriptVector0 : packoffset(c23);
    float4 scriptVector1 : packoffset(c24);
    float4 scriptVector2 : packoffset(c25);
    float4 scriptVector3 : packoffset(c26);
    float4 scriptVector4 : packoffset(c27);
    float4 scriptVector5 : packoffset(c28);
    float4 scriptVector6 : packoffset(c29);
    float4 scriptVector7 : packoffset(c30);
    float4 weaponParam0 : packoffset(c31);
    float4 weaponParam1 : packoffset(c32);
    float4 weaponParam2 : packoffset(c33);
    float4 weaponParam3 : packoffset(c34);
    float4 weaponParam4 : packoffset(c35);
    float4 weaponParam5 : packoffset(c36);
    float4 weaponParam6 : packoffset(c37);
    float4 weaponParam7 : packoffset(c38);
    float4 weaponParam8 : packoffset(c39);
    float4 weaponParam9 : packoffset(c40);
    float4 flagParams : packoffset(c41);
    float3 occlusionAmount : packoffset(c42);
    float4 colorObjMin : packoffset(c43);
    float4 colorObjMax : packoffset(c44);
    float colorObjMinBaseBlend : packoffset(c45);
    float colorObjMaxBaseBlend : packoffset(c45.y);
    float2 uvScroll : packoffset(c45.z);
    float4 featherParms : packoffset(c46);
    float4 falloffParms : packoffset(c47);
    float4 falloffBeginColor : packoffset(c48);
    float4 falloffEndColor : packoffset(c49);
    float4 eyeOffsetParms : packoffset(c50);
    float4 alphaDissolveParms : packoffset(c51);
    float4 spotLightWeight : packoffset(c52);
    float4 detailScale : packoffset(c53);
    float4 detailScale1 : packoffset(c54);
    float4 detailScale2 : packoffset(c55);
    float4 detailScale3 : packoffset(c56);
    float4 detailScale4 : packoffset(c57);
    float4 alphaRevealParms : packoffset(c58);
    float4 alphaRevealParms1 : packoffset(c59);
    float4 alphaRevealParms2 : packoffset(c60);
    float4 alphaRevealParms3 : packoffset(c61);
    float4 alphaRevealParms4 : packoffset(c62);
    float4 colorDetailScale : packoffset(c63);
    float4 colorTint : packoffset(c64);
}


SamplerState colorMapSampler_s : register(s0);
Texture2D<float4> colorMapSampler : register(t0);


// 3Dmigoto declarations
#define cmp -


// =============================================================================
// MAIN
// =============================================================================

void main(
    float4 v0 : SV_Position0,
    float4 v1 : TEXCOORD0,
    out float4 o0 : SV_Target0)
{
    float4 r0, r1, r2, r3, r4;
    uint4 bitmask, uiDest;
    float4 fDest;


    // =========================================================================
    // VIDEO REGION 1
    // =========================================================================

    r0.xyzw =
        float4(
            16.0f,
            16.0f,
            16.0f,
            16.0f
        )
        + v1.zwzw;


    r0.xyzw =
        float4(
            0.03125f,
            0.03125f,
            0.03125f,
            0.03125f
        )
        * r0.xyzw;


    r0.xyzw = floor(r0.xyzw);


    r0.xy =
        float2(
            0.0166666675f,
            0.0444444455f
        )
        * r0.xy;


    r1.xyzw =
        r0.zwzw
        * float4(
            0.00833333377f,
            0.0222222228f,
            0.00833333377f,
            0.0222222228f
        )
        + float4(
            0.666666687f,
            0.0f,
            0.666666687f,
            0.5f
        );


    r0.xyzw =
        colorMapSampler.Sample(
            colorMapSampler_s,
            r0.xy
        ).wxyz;


    r2.xyzw =
        colorMapSampler.Sample(
            colorMapSampler_s,
            r1.xy
        ).xyzw;


    r1.xyzw =
        colorMapSampler.Sample(
            colorMapSampler_s,
            r1.zw
        ).xyzw;


    // Reconstruct packed YUV components.
    r0.z = r1.w;
    r0.y = r2.w;


    // =========================================================================
    // LIMITED-RANGE BLACK LEVEL FIX - VIDEO 1
    // =========================================================================
    //
    // r0.x is the luma/Y component.
    //
    // Original:
    //     Y = texture value directly
    //
    // Limited range:
    //     16/255 should actually represent black.
    //
    // Correct that before the chroma conversion.
    //

    r0.x = DecodeVideoLuma(r0.x);


    // Center chroma around zero.
    r0.xyz =
        float3(
            0.0f,
            -0.5f,
            -0.5f
        )
        + r0.xyz;


    // -------------------------------------------------------------------------
    // Original YUV -> RGB conversion
    // -------------------------------------------------------------------------

    r0.w =
        0.580600023f
        * r0.z;


    r0.w =
        r0.y
        * -0.394650012f
        + -r0.w;


    r1.y =
        r0.x
        + r0.w;


    r1.xz =
        r0.zy
        * float2(
            1.13982999f,
            2.03221011f
        )
        + r0.xx;


    // r1.xyz = first SDR video RGB image.


    // =========================================================================
    // VIDEO REGION 2
    // =========================================================================

    r0.xy =
        float2(
            0.000781250012f,
            0.00138888892f
        )
        * v1.xy;


    r2.xyzw =
        max(
            float4(
                0.000390625006f,
                0.0f,
                0.000781250012f,
                0.00138888892f
            ),
            r0.xyxy
        );


    r2.xyzw =
        min(
            float4(
                0.999609351f,
                1.0f,
                0.999218762f,
                0.998611093f
            ),
            r2.xyzw
        );


    r0.zw =
        float2(
            0.666666687f,
            1.0f
        )
        * r2.xy;


    r2.xyzw =
        r2.zwzw
        * float4(
            0.333333343f,
            0.5f,
            0.333333343f,
            0.5f
        )
        + float4(
            0.666666687f,
            0.0f,
            0.666666687f,
            0.5f
        );


    r3.xyzw =
        colorMapSampler.Sample(
            colorMapSampler_s,
            r0.zw
        ).xyzw;


    r3.x = r3.w;


    // Original validity / transparency test.
    r0.z =
        cmp(
            0.0156862754f
            >= r3.w
        );


    r4.xyzw =
        colorMapSampler.Sample(
            colorMapSampler_s,
            r2.xy
        ).xyzw;


    r2.xyzw =
        colorMapSampler.Sample(
            colorMapSampler_s,
            r2.zw
        ).xyzw;


    r3.z = r2.w;
    r3.y = r4.w;


    // =========================================================================
    // LIMITED-RANGE BLACK LEVEL FIX - VIDEO 2
    // =========================================================================
    //
    // r3.x is the second video's luma/Y value.
    //

    r3.x = DecodeVideoLuma(r3.x);


    r2.xyz =
        float3(
            0.0f,
            -0.5f,
            -0.5f
        )
        + r3.xyz;


    // -------------------------------------------------------------------------
    // Original second YUV -> RGB conversion
    // -------------------------------------------------------------------------

    r0.w =
        0.580600023f
        * r2.z;


    r0.w =
        r2.y
        * -0.394650012f
        + -r0.w;


    r3.y =
        r2.x
        + r0.w;


    r3.xz =
        r2.zy
        * float2(
            1.13982999f,
            2.03221011f
        )
        + r2.xx;


    // Preserve original invalid/transparent behavior.
    r2.xyz =
        r0.zzz
        ? float3(
            0.0f,
            0.0f,
            0.0f
        )
        : r3.xyz;


    // =========================================================================
    // ORIGINAL REGION / FRAME COMPOSITING
    // =========================================================================

    r1.xyz =
        -r2.xyz
        + r1.xyz;


    r0.zw =
        cmp(
            r0.xy
            >= scriptVector0.xz
        );


    r0.xy =
        cmp(
            scriptVector0.yw
            >= r0.xy
        );


    r0.x =
        r0.x
        ? r0.z
        : 0.0f;


    r0.x =
        r0.w
        ? r0.x
        : 0.0f;


    r0.x =
        r0.y
        ? r0.x
        : 0.0f;


    r0.x =
        r0.x
        ? 1.0f
        : 0.0f;


    // =========================================================================
    // FINAL SDR VIDEO
    // =========================================================================

    float3 videoColor =
        r0.xxx
        * r1.xyz
        + r2.xyz;


    // Negative YUV conversion undershoot is not valid display light.
    //
    // Do NOT clamp the upper range here yet because this is still before
    // deciding between SDR and HDR behavior.
    videoColor = max(videoColor, 0.0f);


    // =========================================================================
    // RENO DX VIDEO-ONLY HDR ITM
    // =========================================================================

    if (RENODX_TONE_MAP_TYPE != 0.0f)
    {
        // The source FMV itself is SDR, so its legitimate source range is
        // 0-1 before inverse tonemapping.
        videoColor = saturate(videoColor);


        // RenoDX video-specific path:
        //
        // gamma 2.4 decode
        //      ->
        // BT.2446a inverse tonemap
        //      ->
        // Peak White / Diffuse White HDR expansion
        //      ->
        // gamma 2.4 encode
        //
        videoColor =
            renodx::draw::UpscaleVideoPass(
                videoColor
            );
    }


    // =========================================================================
    // OUTPUT
    // =========================================================================

    o0.xyz = videoColor;

    // Original shader always outputs opaque alpha.
    o0.w = 1.0f;

    return;
}
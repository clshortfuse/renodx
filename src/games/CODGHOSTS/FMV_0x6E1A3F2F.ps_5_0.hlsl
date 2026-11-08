// ---- Created with 3Dmigoto v1.3.16 on Fri Aug 07 17:20:10 2026
//
// Call of Duty: Ghosts
// RenoDX FMV / Video HDR replacement
//
// - Preserves the game's original YUV -> RGB conversion.
// - Preserves original alpha.
// - Preserves original vertex tint / fade.
// - SDR mode remains the original shader.
// - HDR mode applies RenoDX's built-in BT.2446a video ITM.
// - Does NOT include common.hlsl, because the normal scene-tonemapping
//   helpers are not required for FMV rendering.
//
// RenoDX's UpscaleVideoPass:
//   Gamma SDR video
//       -> gamma 2.4 decode
//       -> BT.2446a inverse tone mapping
//       -> scale to RenoDX peak/diffuse white
//       -> gamma encode
//

#include "./shared.h"


Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);


SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);


// 3Dmigoto declarations
#define cmp -


void main(
    float4 v0 : SV_POSITION0,
    float2 v1 : TEXCOORD0,
    float4 v2 : COLOR0,
    out float4 o0 : SV_TARGET0)
{
    float4 r0, r1;
    uint4 bitmask, uiDest;
    float4 fDest;


    // -------------------------------------------------------------------------
    // ORIGINAL VIDEO PLANE SAMPLING
    // -------------------------------------------------------------------------

    // Alpha / fourth plane
    r0.w = t7.Sample(s7_s, v1.xy).x;

    // Video YUV planes
    r1.y = t5.Sample(s5_s, v1.xy).x;
    r1.z = t6.Sample(s6_s, v1.xy).x;
    r1.x = t4.Sample(s4_s, v1.xy).x;

    r1.w = 1.0f;


    // -------------------------------------------------------------------------
    // ORIGINAL YUV -> RGB CONVERSION
    // -------------------------------------------------------------------------

    r0.y =
        dot(
            float4(
                1.0f,
                -0.714139998f,
                -0.344139993f,
                0.531215072f
            ),
            r1.xyzw
        );

    r0.x =
        dot(
            float3(
                1.0f,
                1.40199995f,
                -0.703749001f
            ),
            r1.xyw
        );

    r0.z =
        dot(
            float3(
                1.0f,
                1.77199996f,
                -0.889474511f
            ),
            r1.xzw
        );


    // -------------------------------------------------------------------------
    // RENO DX VIDEO-ONLY INVERSE TONEMAPPING
    // -------------------------------------------------------------------------
    //
    // UpscaleVideoPass is specifically designed for SDR video.
    //
    // It:
    //
    //   1. Decodes gamma 2.4
    //   2. Calculates video peak from:
    //        Peak White / Diffuse White
    //   3. Applies BT.2446a inverse tone mapping
    //   4. Scales the video into the RenoDX HDR brightness range
    //   5. Re-encodes the result
    //
    // It is intentionally applied BEFORE v2 so that movie fades/tints
    // remain game-controlled instead of becoming part of the ITM input.
    //

    if (RENODX_TONE_MAP_TYPE != 0.0f)
    {
        // YUV conversion can produce tiny negative/over-range values.
        // BT.2446a expects an SDR video image.
        float3 videoColor = saturate(r0.rgb);

        videoColor =
            renodx::draw::UpscaleVideoPass(
                videoColor
            );

        r0.rgb = videoColor;
    }


    // -------------------------------------------------------------------------
    // ORIGINAL OUTPUT
    // -------------------------------------------------------------------------
    //
    // Keep the game's original vertex colour/fade multiplication.
    //

    o0.xyzw = v2.xyzw * r0.xyzw;

    return;
}
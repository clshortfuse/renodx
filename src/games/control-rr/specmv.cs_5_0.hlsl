/*
 * Copyright (C) 2026 speedlemur
 * SPDX-License-Identifier: MIT
 */

// control-rr: specular motion vectors for DLSS-RR. Per-pixel motion of the
// REFLECTED image, which is not the motion of the surface it appears on.
//
// The reflected object appears along THIS pixel's own view ray, pushed back
// by the ray's path length — that is why a mirror reads as a window into a
// room behind it. Anything visible at a pixel lies on that pixel's ray by
// definition, so:
//
//   virtualPos = surfacePos + viewDir * hitT
//   specMV     = gameMV + (NdcDelta(virtual) - NdcDelta(surface))
//
// NOT surfacePos + reflect(viewDir, normal) * hitT — that is where the
// OBJECT is, which projects to a different pixel.
//
// The output is a CORRECTION on top of the game's own MV texture:
//  - the game's MV convention (units, sign, jitter handling) is inherited,
//    not guessed; MvOutScale only converts the ndc-space correction term
//  - jitter cancels exactly in (virtualDelta - surfaceDelta): both share
//    the same jittered matrices
//  - gameMV carries camera AND object motion while our correction is
//    camera-only, so the result is the reflection's camera motion plus the
//    surface's object motion
//  - as the effective distance goes to zero the correction goes to zero and
//    we emit gameMV unchanged, the correct limit
//
// CURVATURE IS DELIBERATELY IGNORED. For a flat reflector the curvature
// magnification factor is exactly 1, and Control's mirror-likes are flat.
//
// Hit distance comes from the RT reflection shading pass's own inputs
// (0xABEC7E90): per-ray hit-attribute arrays
// filled by the DXR trace, slice = ray index. g_tPosition_TexcoordY.xyz is
// the VIEW-space hit position — that shader computes
// length(hitPosView - ClipToView * clip) itself for its distance test, and
// we compute exactly that. MIN over the rays: min biases toward the
// surface, whose limit is the safe fallback. No spatial gather: the taps
// are real hit points, not Monte Carlo speckle.
//
// Matrices are the game's own sys_constants, in Control's row-vector
// convention (v * M), passed raw — row_major + mul(v, M) here matches.

cbuffer Params : register(b0)
{
    row_major float4x4 ClipToView;      // g_mClipToView      (+224)
    row_major float4x4 ViewToClip;      // g_mViewToClip      (+160)
    row_major float4x4 ClipToPrevClip;  // g_mClipToPreviousClip (+416)
    uint Width;
    uint Height;
    float MvOutScaleX;                  // ndc delta -> game MV units
    float MvOutScaleY;
    uint Layers;                        // slices in the hit arrays (rays per pixel)
};

Texture2D<float4> GBuffer1 : register(t0);      // .z = GLOSS (1 = mirror)
Texture2DArray<uint> MatId : register(t1);      // g_tMaterialId, R16_UINT
Texture2D<float> Depth : register(t2);          // game HW depth
Texture2D<float2> GameMV : register(t3);        // game motion vectors
Texture2DArray<float4> HitPos : register(t4);   // g_tPosition_TexcoordY, .xyz view-space hit

RWTexture2D<float2> SpecMV : register(u0);
#ifndef NDEBUG
// Evidence texture for the diagnostic dump: (hit_t, effective_t, |correction|
// in game MV units, applied flag). Written for every pixel.
RWTexture2D<float4> Debug : register(u1);
#endif

#define MATID_NO_RAY 0xFFFE   // no more rays for this pixel
#define MATID_SKY    0xFFFF   // ray escaped: no finite hit, excluded from the min

// An ndc-space correction beyond this is not a reflection, it is a bad
// matrix or a bad distance. Ndc spans [-1,1], so 1.0 is half the screen in
// one frame. Unit-free on purpose: independent of the game's MV convention.
#define NDC_CORRECTION_MAX 1.0

float3 ViewPos(int2 p)
{
    float z = Depth.Load(int3(p, 0));
    float2 uv = (float2(p) + 0.5) / float2(Width, Height);
    float2 ndc = float2(uv.x * 2.0 - 1.0, 1.0 - uv.y * 2.0);
    float4 v = mul(float4(ndc, z, 1.0), ClipToView);
    return v.xyz / v.w;
}

// Shortest finite ray length at this pixel; 0 when no ray hit anything.
float MinHitDistance(int2 p, float3 surface_pos)
{
    float best = 3.402823466e38;
    bool any_hit = false;
    for (uint s = 0; s < Layers; ++s)
    {
        uint id = MatId.Load(int4(p, s, 0));
        if (id == MATID_NO_RAY)
            break;
        if (id == MATID_SKY)
            continue;
        float3 hit = HitPos.Load(int4(p, s, 0)).xyz;
        float d = length(hit - surface_pos);
        if (d > 0.0)
        {
            best = min(best, d);
            any_hit = true;
        }
    }
    return any_hit ? best : 0.0;
}

float2 NdcDelta(float3 view_pos)
{
    // current clip -> previous clip, both through the game's own matrices
    float4 clip_now = mul(float4(view_pos, 1.0), ViewToClip);
    float2 ndc_now = clip_now.xy / clip_now.w;
    float4 clip_prev = mul(clip_now, ClipToPrevClip);
    float2 ndc_prev = clip_prev.xy / clip_prev.w;
    return ndc_prev - ndc_now;
}

[numthreads(16, 16, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    if (tid.x >= Width || tid.y >= Height)
        return;

    float2 game_mv = GameMV.Load(int3(tid.xy, 0));
    float gloss = GBuffer1.Load(int3(tid.xy, 0)).z;

    float3 surface_pos = ViewPos(int2(tid.xy));
    float hit_t = MinHitDistance(int2(tid.xy), surface_pos);

    // Roughness fade. A blurred reflection averages a cone of directions, so
    // its apparent parallax shrinks with roughness; at fully diffuse the
    // image sits on the surface and moves with it. Continuous on purpose —
    // a hard gloss threshold puts a cliff in the motion field along every
    // material boundary. The exponent is a free knob; the endpoints are not.
    float effective_t = hit_t * gloss * gloss;

    // No usable reflection distance: emit surface motion. Written negated so
    // zero, NaN and a fully diffuse surface all land here together.
    if (!(effective_t > 0.0))
    {
        SpecMV[tid.xy] = game_mv;
#ifndef NDEBUG
        Debug[tid.xy] = float4(hit_t, effective_t, 0.0, 0.0);
#endif
        return;
    }

    float3 view_dir = normalize(surface_pos);
    float3 virtual_pos = surface_pos + view_dir * effective_t;

    float2 correction = NdcDelta(virtual_pos) - NdcDelta(surface_pos);

    if (!all(abs(correction) < NDC_CORRECTION_MAX))
    {
        SpecMV[tid.xy] = game_mv;
#ifndef NDEBUG
        Debug[tid.xy] = float4(hit_t, effective_t, 0.0, -1.0);  // rejected
#endif
        return;
    }

    float2 scaled = correction * float2(MvOutScaleX, MvOutScaleY);
    SpecMV[tid.xy] = game_mv + scaled;
#ifndef NDEBUG
    Debug[tid.xy] = float4(hit_t, effective_t, length(scaled), 1.0);
#endif
}

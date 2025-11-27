#include "./shared.h"

// TV Noise overlay effect (shows up later in the game)
sampler2D ActualFrameSampler : register(s0);
sampler2D Sampler0           : register(s1);
sampler2D Sampler1           : register(s2);
sampler2D Sampler2           : register(s3);

float g_Value   : register(c0);
float FrameTime : register(c1);
float FramePhase: register(c2);

float4 main(float2 uv : TEXCOORD) : COLOR
{
    float4 A, B, C, D;   // renamed r0–r3 for structure
    float3 M;            // renamed r4
    float4 OUT;          // output

    // -------------------------------------------------------------------------
    // RANDOMIZED TIME / VERTICAL FALLOFF SETUP
    // -------------------------------------------------------------------------

    // Base constants (0.1, 17.5, 26.4, 0.5)
    A = float4(0.1, 17.5, 26.4, 0.5);

    // Temporal seeds
    B.xyz = FrameTime * A.xyz + A.w;
    C.xyz = frac(B.xyz);
    B.xyz = B.xyz - C.xyz;

    // Temporal offset corrected with integer part
    A.xyz = FrameTime * A.xyz - B.xyz;

    // Vertical gradient influence
    A.xyz = A.xyz * 3.0 - float3(uv.y, uv.y, uv.y);

    // Falloff shape
    A.xyz = saturate(-abs(A.xyz) + float3(0.8, 0.6, 0.3));
    A.xyz = A.xyz * float3(1.25, 1.66666663, 3.33333325);

    // Shape squaring
    A.xyz = A.xyz * A.xyz;
    D.xyz = A.xyz * A.xyz;

    // Additional shape mixing
    A.w  = A.y * D.y;
    D.w  = A.w * 0.3 + 0.85;
    D.y  = saturate(D.x * 0.6 + 0.8);

    // -------------------------------------------------------------------------
    // TILE NOISE SAMPLING
    // -------------------------------------------------------------------------

    float2 tileUV = uv * 15.0;

    float4 T0 = tex2D(Sampler0, tileUV);
    float4 T1 = tex2D(Sampler1, tileUV);
    float4 T2 = tex2D(Sampler2, tileUV);
    float4 T2Inverted = 1.0 - T2;
    // Mix-in high-frequency noise
    if (RENODX_TONE_MAP_TYPE > 0.f) {
      A = (T2 * 1.0) + (T2Inverted * 0.75);
    } else {
      A = T2 * 0.1 + 0.9;
    }

    // Blend between two tile textures
    M = lerp(T0.xyz, T1.xyz, FramePhase);

    // Add blended noise color tint
    A *= 0.8;
    A.xyz = M * float3(0.2, 0.12, 0.06) + A.xyz;

    // -------------------------------------------------------------------------
    // EDGE MASKING / SHAPE MODULATION
    // -------------------------------------------------------------------------

    C.z = D.z * D.z;      // squared falloff

    // Local modulation
    B = A - 0.3;
    B = saturate(B * 1.5);
    B *= D.y;

    // Top-left region mask
    C.xy = saturate(float2(0.02, 0.02) - uv);
    C.xy *= 50.0;

    float edgeAccum = C.x + C.y;

    // Bottom-right region mask
    C.xy = saturate(uv + (-0.98));
    B *= D.w;

    edgeAccum = C.x * 50.0 + edgeAccum;
    C.z = C.z * 0.2 + 0.9;

    edgeAccum = C.y * 50.0 + edgeAccum;
    B *= C.z;

    D.w = edgeAccum * edgeAccum;

    // -------------------------------------------------------------------------
    // FINAL COMPOSITION
    // -------------------------------------------------------------------------

    C = tex2D(ActualFrameSampler, uv);

    A = A * g_Value + C;       // blend noise onto frame
    float mask = saturate(D.w * D.w);
    if (RENODX_TONE_MAP_TYPE > 0.f) {
      A -= 0.10;
    } else {
      A += 0.025;
    }

    OUT = A * B - mask;  // final combine
    if (RENODX_TONE_MAP_TYPE > 0.f) {
        // REMOVE GREY CAST
        float3 original = C.rgb;          // original frame
        float3 effected = OUT.rgb;        // effect result

        // Estimate grey offset by comparing average luminance drift
        float l_orig = dot(original, float3(0.2126, 0.7152, 0.0722));
        float l_eff  = dot(effected, float3(0.2126, 0.7152, 0.0722));

        // Offset produced by the effect
        float greyBias = l_eff - l_orig;

        // Remove the uniform grey bias
        effected -= greyBias;

        effected = max(effected, 0.0);
        OUT.rgb = lerp(OUT.rgb, effected, effected);
    }	
    return OUT;
}

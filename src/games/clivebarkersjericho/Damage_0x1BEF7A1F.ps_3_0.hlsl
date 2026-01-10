#include "./shared.h"

// Damage red vingetting overlay and color tint
sampler2D ActualFrameSampler : register(s0);
float g_Value : register(c0); // scaling factor for hit effect
float g_FX    : register(c1); // X offset
float g_FY    : register(c2); // Y offset

// ASM constants
static const float4 OFFSET = float4(0.5, -1.5, 2.0, 1.0);        // C3
static const float4 LUMA   = float4(0.299, 0.587, 0.114, 0.33); // C4
static const float4 SCALE  = float4(0.6, 0.2, 4.0, 0.0);        // C5
static const float4 TINT   = float4(0.8, 0.1, 0.0, 0.0);        // C6

float4 main(float2 uv : TEXCOORD0) : COLOR0
{
    // intermediate registers
    float4 r0 = 0;
    float4 r1 = 0;
    float4 r2 = 0;

    // --- UV offsets, absolute differences, and axis maxima
    r1.w = uv.x - g_FX;                       // r1.w = v0.x - g_FX
    r0 = float4(uv.x, uv.x, uv.y, uv.y) + float4(OFFSET.x, OFFSET.y, OFFSET.x, OFFSET.y);
    r1.w += OFFSET.z;                          // add 2
    r0 = abs(r0) * OFFSET.x;                   // multiply by 0.5
    r1.w = abs(r1.w) * OFFSET.x;
    r1.x = max(r0.x, r0.y);                    // x-axis max
    r1.y = max(r0.z, r0.w);                    // y-axis max

    // --- conditional selection
    r0.z = (-g_FX >= 0.0) ? r1.x : r1.w;

    // --- Y-axis processing
    r0.w = uv.y - g_FY;
    r0.y = r0.z * r0.z;
    r0.w += OFFSET.z;                          // add 2
    r0.y = r0.y * r0.y;
    r0.w = abs(r0.w) * OFFSET.x;
    r1.x = saturate(r0.z * r0.y);
    r1.z = (-g_FY >= 0.0) ? r1.y : r0.w;

    // --- sample frame and compute luminance
    r0 = tex2D(ActualFrameSampler, uv);
    r1.w = dot(r0.rgb, LUMA.xyz);             // luminance
    r1.y = r1.z * r1.z;
    r1.w = saturate(r1.w * LUMA.w);
    r1.y = r1.y * r1.y;
    r1.w = 1.0 - r1.w;
    r1.y = saturate(r1.z * r1.y);
    r1.z = r1.w * r1.w;

    // --- combine max and scaling
    r2.w = saturate(max(r1.x, r1.y));
    r1.w *= r1.z;
    r1.z = OFFSET.x;
    r1.y = saturate(g_Value * r2.w + r1.z);

    // --- mask scaling and radial adjustments
    r1.x = r1.w * SCALE.x;
    r1.w = SCALE.y;
    r1.z = r2.w * g_Value;
    float tmpX = r1.y * r1.x;
    float tmpW = r1.y * r1.w;
    r1.x = tmpX;
    r1.w = tmpW;

    r1.y = rsqrt(r1.z);                        // 1 / sqrt(r1.z)
    r2.w = r2.w * SCALE.z;
    r1.y = 1.0 / r1.y;                         // sqrt(r1.z)
    r1.z = r1.z * -OFFSET.x + 1.0;

    r1.x = saturate(r1.x * r1.y);
    r1.w = saturate(r1.w * r1.y);

    r1.x = r0.x * r1.z + r1.x;
    r1.w = r0.w * r1.z + r1.w;
    r1.y = r0.y * r1.z;
    r1.z = r0.z * r1.z;

    // --- final tint blend
    r0.w = r2.w * r2.w;
    r2.w = saturate(r0.w * r0.w);
    r2.z = saturate(g_Value);
    r0 = -r1 + float4(TINT.x, TINT.y, TINT.y, TINT.z);
    r2.w *= r2.z;

    float4 outCol = (r2.w * r0 + r1);
    return outCol;
}

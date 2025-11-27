#include "./shared.h"

// HDR Bright-pass
float g_fMiddleGray            : register(c0);
float g_BRIGHT_PASS_THRESHOLD  : register(c1);
float g_BRIGHT_PASS_OFFSET     : register(c2);

sampler2D s0 : register(s0); // input HDR texture
sampler2D s1 : register(s1); // exposure / luminance texture

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
    float4 o;
    float4 r0;
    float4 r1;

    // sample luminance/exposure at fixed UV 0.5 (center)
    r0 = tex2D(s1, float2(0.5, 0.5));

    // compute scaling factor
    r0.w = r0.x + 0.001;          // avoid division by zero
    r0.w = 1.0 / r0.w;
    r0.w *= g_fMiddleGray;        // scale by middle gray

    // sample HDR color
    r1 = tex2D(s0, texcoord);

    // apply threshold and scaling
    r1.xyz = r1.xyz * r0.w - g_BRIGHT_PASS_THRESHOLD * lerp(1.f, 4.f, Custom_BrightPass_Thresholding);

    // clamp negative values
    r0 = max(r1, float4(0.0, 0.0, 0.0, 0.0));

    // add offset
    r1.xyz = r0.xyz + g_BRIGHT_PASS_OFFSET * lerp(1.f, 4.f, Custom_BrightPass_Thresholding);

    // reciprocal per channel
    r1.x = 1.0 / r1.x;
    r1.y = 1.0 / r1.y;
    r1.z = 1.0 / r1.z;

    // final color = scaled color
    o.xyz = r0.xyz * r1.xyz;
    o.w   = r0.w; // preserve alpha (if any)

    return o;
}

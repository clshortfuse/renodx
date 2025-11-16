#include "./shared.h"

// Some weird sharpening
float4 CopySharpenValues : register( c0 );
sampler2D s0 : register( s0 );

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
    float4 r0, r1;
	CopySharpenValues.xy *= Custom_Sharpening_Amount;
    // Sample left
    r0 = tex2D(s0, texcoord + float2(-CopySharpenValues.x, 0));
    r1 = r0 * CopySharpenValues.w;

    // Sample center
    r0 = tex2D(s0, texcoord);
    r1 = r0 * CopySharpenValues.z - r1;

    // Sample right
    r0 = tex2D(s0, texcoord + float2(CopySharpenValues.x, 0));
    r1 = r1 - r0 * CopySharpenValues.w;

    // Sample top
    r0 = tex2D(s0, texcoord + float2(0, -CopySharpenValues.y));
    r1 = r1 - r0 * CopySharpenValues.w;

    // Sample bottom
    r0 = tex2D(s0, texcoord + float2(0, CopySharpenValues.y));
    r1 = r1 - r0 * CopySharpenValues.w;

    return r1; // final sharpened color
}

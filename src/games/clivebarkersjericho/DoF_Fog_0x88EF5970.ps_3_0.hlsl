#include "./shared.h"

// DoF, Water and Fog
float DOFFogDesaturate : register(c15);
float DOFFogDist : register(c10);
float DOFFogFactorBlur : register(c14);
float DOFFogFactorGray : register(c13);
float DOFFogFactorScene : register(c12);
float DOFFogRange : register(c11);
float4 FogColor : register(c8);
float FogDensity : register(c9);
float FogDistance : register(c6);
float FogRange : register(c7);
float RenderMult : register(c16);
float g_Value : register(c0);
float g_ZDistFar : register(c1);
float g_ZRangeFar : register(c2);
float g_ZDistNear : register(c3);
float g_ZRangeNear : register(c4);
float g_ZNullDist : register(c5);

sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);

float4 main(float2 v0 : TEXCOORD) : COLOR
{
    float4 r0 = tex2D(s2, v0);
    float r2_z = (-r0.x >= 0) ? g_ZNullDist : r0.x;

    float r0_x = 1.0 / g_ZRangeFar;
    float r1_w = r2_z - g_ZDistFar;
    float r0_y = max(r1_w, 0.0);

    float r0_w = r2_z - g_ZDistNear;
    float r0_z = 1.0 / g_ZRangeNear;
    r0_w = (r0_w >= 0.0) ? 0.0 : -r0_w;

    float r1_z = r0_x * r0_y;
    float r1_w2 = r0_z * r0_w;

    r0_x = min(r1_z, 1.0);
    r0_z = min(r1_w2, 1.0);

    r1_z = (-r0_y >= 0.0) ? r0_y : r0_x;
    r1_w2 = (-r0_w >= 0.0) ? r0_w : r0_z;

    r0_w = max(r1_z, r1_w2);

    float r2_x = r0_w * g_Value;

    float4 r0_tex = tex2D(s0, v0);
    float4 r3_tex = tex2D(s1, v0);

    r1_w = r2_z - FogDistance;
    float r2_w = max(r1_w, 0.0);
    float r2_y = 1.0 / FogRange;

    float4 r1 = lerp(r0_tex, r3_tex, r2_x);
    r2_w = saturate(r2_w * r2_y);

    r0 = FogColor * RenderMult - r1;
    r2_w *= FogDensity;
    r1 = r2_w * r0 + r1;

    float r2_luma = dot(r1.rgb, float3(0.2126, 0.7152, 0.0722));

    float r4_w = r2_z - DOFFogDist;
    float3 r0_rgb = lerp(r1.rgb, r2_luma.xxx, DOFFogDesaturate);

    r2_w = max(r4_w, 0.0);
    r0_z = 1.0 / DOFFogRange;
    r4_w = saturate(r2_w * r0_z);

    float r4_luma = dot(r3_tex.rgb, float3(0.2126, 0.7152, 0.0722));
    float3 r2_rgb = r0_rgb * r4_w;
    float3 r0b = (-r3_tex.rgb + r4_luma) * DOFFogDesaturate;
    r2_rgb *= DOFFogFactorGray;

    float r4_z = r4_w * (-DOFFogFactorScene) + 1.0;
    float3 r0c = r4_w * r0b + r3_tex.rgb;
    float3 r1_rgb = r1.rgb * r4_z + r2_rgb;

    r0c *= r4_w;
    float3 final = r0c * DOFFogFactorBlur + r1_rgb;

    return float4(final, r1.a);
}

// Mechanically reconstructed from 0x372E7EBC.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(1.00000072f, 0.5f, 6.28318548f, -3.14159274f);
    const float4 c1 = float4(0.0f, -1.0f, 1.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0.x = (c[20].w) * (v4.x);
    r0.x = (r0.x) * (c0.x) + (c0.y);
    r0.x = frac(r0.x);
    r0.x = (r0.x) * (c0.z) + (c0.w);
    r1.xy = float2(cos(r0.x), sin(r0.x));
    r0.xy = (r1.yx) * (c1.yz);
    r0.zw = (-(c0.yy)) + (v3.xy);
    r0.y = dot(r0.xy, r0.zw) + (c1.x);
    r0.x = dot(r1.xy, r0.zw) + (c1.x);
    r0.xy = (r0.xy) + (c0.yy);
    r0 = tex2D(s1, r0.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1 = (c[5]) + (-(v1.xxxx));
    r2 = (c[6]) + (-(v1.yyyy));
    r3 = (r2) * (r2);
    r3 = (r1) * (r1) + (r3);
    r4 = (c[7]) + (-(v1.zzzz));
    r3 = (r4) * (r4) + (r3);
    r5.x = rsqrt(r3.x);
    r5.y = rsqrt(r3.y);
    r5.z = rsqrt(r3.z);
    r5.w = rsqrt(r3.w);
    r6.z = c1.z;
    r3 = saturate((r3) * (c[8]) + (r6.zzzz));
    r1 = (r1) * (r5);
    r2 = (r2) * (r5);
    r4 = (r4) * (r5);
    r5.xyz = normalize(v2.xyz);
    r2 = (r2) * (r5.yyyy);
    r1 = (r1) * (r5.xxxx) + (r2);
    r1 = saturate((r4) * (r5.zzzz) + (r1));
    r1 = (r3) * (r1);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r2.z = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r0.xyz);
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c1.z;

    return oC0;
}

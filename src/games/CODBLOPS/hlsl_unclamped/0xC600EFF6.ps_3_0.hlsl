// Mechanically reconstructed from 0xC600EFF6.ps_3_0.cso.
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
    float4 v2 : TEXCOORD4;
    float4 v3 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    const float4 c0 = float4(0.0f, -1.0f, 1.0f, 0.0f);
    const float4 c1 = float4(1.00000072f, 0.5f, 6.28318548f, -3.14159274f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 oC0 = 0.0f;

    r0.x = (c[5].w) * (v3.x);
    r0.x = (r0.x) * (c1.x) + (c1.y);
    r0.x = frac(r0.x);
    r0.x = (r0.x) * (c1.z) + (c1.w);
    r1.xy = float2(cos(r0.x), sin(r0.x));
    r0.xy = (r1.yx) * (c0.yz);
    r0.zw = (-(c1.yy)) + (v2.xy);
    r0.y = dot(r0.xy, r0.zw) + (c0.x);
    r0.x = dot(r1.xy, r0.zw) + (c0.x);
    r0.xy = (r0.xy) + (c1.yy);
    r0 = tex2D(s1, r0.xy);
    r0.xyz = (r0.xyz) * (r0.xyz) + (-(v0.xyz));
    r1.xyz = v0.xyz;
    r0.xyz = (v1.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c0.z;

    return oC0;
}

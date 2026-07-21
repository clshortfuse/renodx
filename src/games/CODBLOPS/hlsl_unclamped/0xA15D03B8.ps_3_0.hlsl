// Mechanically reconstructed from 0xA15D03B8.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(1.0f, 31.875f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r3 = (-(v4.yyyy)) + (c[7]);
    r0 = (r3) * (r3);
    r2 = (-(v4.xxxx)) + (c[6]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v4.zzzz)) + (c[8]);
    r0 = (r1) * (r1) + (r0);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r3 = (r3) * (r4);
    r5.xyz = normalize(v2.xyz);
    r2 = (r2) * (r4);
    r3 = (r3) * (r5.yyyy);
    r1 = (r1) * (r4);
    r2 = (r2) * (r5.xxxx) + (r3);
    r3.w = c0.x;
    r0 = saturate((r0) * (c[9]) + (r3.wwww));
    r1 = saturate((r1) * (r5.zzzz) + (r2));
    r0 = (r0) * (r1);
    r1.x = dot(c[10], r0);
    r1.y = dot(c[11], r0);
    r1.z = dot(c[20], r0);
    r0 = tex2D(s0, v1.xy);
    r1.w = max(abs(r5.y), abs(r5.z));
    r2.xyz = (r0.xyz) * (v0.xyz);
    r0.w = max(abs(r5.x), r1.w);
    r0.xyz = (r5.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r0.w);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v5.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.yyy) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.x;

    return oC0;
}

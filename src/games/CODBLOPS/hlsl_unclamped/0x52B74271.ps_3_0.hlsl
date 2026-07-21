// Mechanically reconstructed from 0x52B74271.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD3;
    float4 v6 : TEXCOORD5;
    float4 v7 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    float4 v6 = input.v6;
    float4 v7 = input.v7;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(1.0f, 31.875f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r3 = (-(v6.yyyy)) + (c[7]);
    r0 = (r3) * (r3);
    r2 = (-(v6.xxxx)) + (c[6]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v6.zzzz)) + (c[8]);
    r4 = tex2D(s1, v1.xy);
    r6.xy = (r4.wy) * (c0.xy) + (c0.zw);
    r0 = (r1) * (r1) + (r0);
    r4.xyz = v2.xyz;
    r5.xyz = (r6.xxx) * (v5.xyz) + (r4.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r6.xyz = (r6.yyy) * (v4.xyz) + (r5.xyz);
    r3 = (r3) * (r4);
    r5.xyz = normalize(r6.xyz);
    r2 = (r2) * (r4);
    r3 = (r3) * (r5.yyyy);
    r1 = (r1) * (r4);
    r2 = (r2) * (r5.xxxx) + (r3);
    r3.w = c1.x;
    r0 = saturate((r0) * (c[9]) + (r3.wwww));
    r1 = saturate((r1) * (r5.zzzz) + (r2));
    r0 = (r0) * (r1);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r2.z = dot(c[20], r0);
    r0 = tex2D(s0, v1.xy);
    r2.w = max(abs(r5.y), abs(r5.z));
    r0 = (r0.wxyz) * (v0.wxyz);
    r1.w = max(abs(r5.x), r2.w);
    r1.xyz = (r5.xyz) * (c[5].xyz);
    r1.w = 1.0f / (r1.w);
    r3.xyz = (r0.yzw) * (r0.yzw);
    r1.xyz = (r1.xyz) * (r1.www) + (v7.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r1.xyz = (r3.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c1.yyy) + (r2.xyz);
    r1.xyz = (r0.xxx) * (r1.xyz);
    r1.w = c1.x;
    r2.x = dot(r1, c[22]);
    r2.y = dot(r1, c[23]);
    r2.z = dot(r1, c[24]);
    r1.xyz = (v3.xyz) * (-(r0.xxx)) + (r2.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r1.xyz = (v3.xyz) * (r0.xxx) + (r1.xyz);
    r1.xyz = max(((r1.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r0.x);
    r0.x = rsqrt(r1.x);
    r0.y = rsqrt(r1.y);
    r0.z = rsqrt(r1.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}

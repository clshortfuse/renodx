// Mechanically reconstructed from 0x03276577.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-1.0f, 1.0f, 0.0f, 0.5f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 31.875f, 4.0f);
    const float4 c3 = float4(4.0f, -2.0f, 2.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 r9 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v0.zw) * (c1.yw);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (c1.yw) + (c1.zw);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r3.xy = (r2.yw) * (c3.xx) + (c3.yy);
    r0.w = dot(r3.xy, r3.xy) + (c1.z);
    r0.w = exp2(-(r0.w));
    r1 = tex2D(s1, v0.xy);
    r1.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1.w = (r0.w) * (c2.x) + (c2.y);
    r0.y = dot(r1.xy, r1.xy) + (c1.z);
    r0.w = dot(r3.xy, r1.xy) + (c1.z);
    r0.y = exp2(-(r0.y));
    r5 = tex2D(s14, v0.zw);
    r9.xy = (r5.xy) * (c2.zz);
    r6.w = (r0.y) * (c2.x) + (c2.y);
    r0.xy = (r0.xz) * (r9.yy);
    r1.z = (r1.w) * (r6.w);
    r1.w = (r5.y) * (c2.z) + (-(r0.x));
    r0.w = saturate((r0.w) * (r1.z) + (r1.z));
    r1.w = (r0.z) * (-(r9.y)) + (r1.w);
    r0.xz = (r0.xy) * (c2.ww);
    r0.y = (r1.w) + (r1.w);
    r7.xyz = (r0.www) * (r0.xyz);
    r2.xy = (r2.xz) * (r9.xx);
    r4 = (-(v3.yyyy)) + (c[6]);
    r0 = (r4) * (r4);
    r3 = (-(v3.xxxx)) + (c[5]);
    r0 = (r3) * (r3) + (r0);
    r1 = (-(v3.zzzz)) + (c[7]);
    r2.w = (r5.x) * (c2.z) + (-(r2.x));
    r0 = (r1) * (r1) + (r0);
    r6.xz = (r6.ww) * (r2.xy);
    r5.x = rsqrt(r0.x);
    r5.y = rsqrt(r0.y);
    r5.z = rsqrt(r0.z);
    r5.w = rsqrt(r0.w);
    r4 = (r4) * (r5);
    r8.xyz = normalize(v1.xyz);
    r3 = (r3) * (r5);
    r4 = (r4) * (r8.yyyy);
    r1 = (r1) * (r5);
    r3 = (r3) * (r8.xxxx) + (r4);
    r2.y = c1.y;
    r0 = saturate((r0) * (c[8]) + (r2.yyyy));
    r1 = saturate((r1) * (r8.zzzz) + (r3));
    r2.w = (r2.z) * (-(r9.x)) + (r2.w);
    r0 = (r0) * (r1);
    r6.y = (r6.w) * (r2.w);
    r2.x = dot(c[9], r0);
    r1 = tex2D(s2, v4.zw);
    r1.xyz = (r1.xyz) + (c1.xxx);
    r2.y = dot(c[10], r0);
    r3.xyz = (v4.yyy) * (r1.xyz) + (c1.yyy);
    r1 = tex2D(s0, v0.xy);
    r1.xyz = (r3.xyz) * (r1.xyz);
    r2.z = dot(c[11], r0);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r6.xyz) * (c3.xzx) + (r7.xyz);
    r2.xyz = (r2.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.y;

    return oC0;
}

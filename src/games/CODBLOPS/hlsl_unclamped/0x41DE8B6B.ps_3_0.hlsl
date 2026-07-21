// Mechanically reconstructed from 0x41DE8B6B.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
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
    const float4 c0 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v0.zw) * (c1.xy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v0.zw) * (c1.xy) + (c1.zy);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r1.xy = (r0.yw) * (c0.xx) + (c0.yy);
    r5 = tex2D(s14, v0.zw);
    r6.xy = (r5.xy) * (c1.ww);
    r0.w = dot(r1.xy, r1.xy) + (c1.z);
    r0.xy = (r0.xz) * (r6.xx);
    r1.w = exp2(-(r0.w));
    r0.w = (r5.x) * (c1.w) + (-(r0.x));
    r6.w = saturate((r1.w) * (c0.z) + (c0.w));
    r0.w = (r0.z) * (-(r6.x)) + (r0.w);
    r7.xz = (r0.xy) * (c0.xx);
    r7.y = (r0.w) + (r0.w);
    r2.xy = (r2.xz) * (r6.yy);
    r4 = (-(v3.yyyy)) + (c[6]);
    r0 = (r4) * (r4);
    r3 = (-(v3.xxxx)) + (c[5]);
    r0 = (r3) * (r3) + (r0);
    r1 = (-(v3.zzzz)) + (c[7]);
    r2.w = (r5.y) * (c1.w) + (-(r2.x));
    r0 = (r1) * (r1) + (r0);
    r6.xz = (r2.xy) * (c0.xx);
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
    r2.y = c1.x;
    r0 = saturate((r0) * (c[8]) + (r2.yyyy));
    r1 = saturate((r1) * (r8.zzzz) + (r3));
    r2.w = (r2.z) * (-(r6.y)) + (r2.w);
    r0 = (r0) * (r1);
    r6.y = (r2.w) + (r2.w);
    r3.x = dot(c[9], r0);
    r2 = tex2D(s0, v0.xy);
    r1 = tex2D(s1, v4.zw);
    r1.xyz = (r1.xyz) * (v4.yyy);
    r3.y = dot(c[10], r0);
    r1.xyz = (r1.xyz) * (r1.www) + (r2.xyz);
    r3.z = dot(c[11], r0);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r6.xyz) * (r6.www) + (r7.xyz);
    r2.xyz = (r3.xyz) * (r0.xyz);
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
    oC0.w = c1.x;

    return oC0;
}

// Mechanically reconstructed from 0x9CDA1474.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s4 : register(s4);
sampler2D s5 : register(s5);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD2;
    float4 v4 : TEXCOORD3;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
    float4 v7 : COLOR1;
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
    const float4 c1 = float4(2.0f, -1.0f, 0.0f, -0.5f);
    const float4 c2 = float4(0.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c3 = float4(31.875f, 4.0f, -2.0f, 0.0f);
    const float4 c4 = float4(0.600000024f, 0.400000006f, 3.5f, 1.0f);
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
    float4 r10 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v0.zw) * (-(c1.yw));
    r3 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (-(c1.yw)) + (-(c1.zw));
    r0 = tex2D(s13, r0.xy);
    r3.w = r0.y;
    r5.xy = (r3.yw) * (c3.yy) + (c3.zz);
    r1 = tex2D(s1, v0.xy);
    r4.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r4.zw = c[20].xy;
    r1 = tex2D(s3, v6.zw);
    r2.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1 = (c1.xxxx) * (v7) + (c1.yyyy);
    r1.x = dot(r2.xy, r1.xy) + (c1.z);
    r1.y = dot(r2.xy, r1.zw) + (c1.z);
    r2 = tex2D(s5, v6.zw);
    r1.zw = r2.yy;
    r6 = tex2D(s2, v6.zw);
    r6.w = (r6.w) * (v6.y) + (c1.w);
    r0.w = dot(r5.xy, r5.xy) + (c1.z);
    r1 = float4(((r6.w) >= 0.0f ? (r1.x) : (r4.x)), ((r6.w) >= 0.0f ? (r1.y) : (r4.y)), ((r6.w) >= 0.0f ? (r1.z) : (r4.z)), ((r6.w) >= 0.0f ? (r1.w) : (r4.w)));
    r0.w = exp2(-(r0.w));
    r0.y = dot(r1.xy, r1.xy) + (c1.z);
    r0.w = (r0.w) * (c4.x) + (c4.y);
    r0.y = exp2(-(r0.y));
    r2 = (r2.wwww) * (c2.xxxy) + (c2.zzzx);
    r5.w = (r0.y) * (c4.x) + (c4.y);
    r4 = tex2D(s14, v0.zw);
    r8.xy = (r4.xy) * (c3.xx);
    r3.y = (r0.w) * (r5.w);
    r0.xy = (r0.xz) * (r8.yy);
    r0.w = dot(r5.xy, r1.xy) + (c1.z);
    r3.w = (r4.y) * (c3.x) + (-(r0.x));
    r0.w = saturate((r0.w) * (r3.y) + (r3.y));
    r3.w = (r0.z) * (-(r8.y)) + (r3.w);
    r0.xz = (r0.xy) * (c3.yy);
    r0.y = (r3.w) + (r3.w);
    r7.xyz = (r0.www) * (r0.xyz);
    r0 = v1;
    r0.xyz = (r1.xxx) * (v4.xyz) + (r0.xyz);
    r3.xy = (r3.xz) * (r8.xx);
    r0.xyz = (r1.yyy) * (v3.xyz) + (r0.xyz);
    r10.xyz = normalize(r0.xyz);
    r0.xyz = normalize(v5.xyz);
    r1.x = (r4.x) * (c3.x) + (-(r3.x));
    r1.y = dot(r0.xyz, r10.xyz);
    r5.xz = (r3.xy) * (c3.yy);
    r1.y = (r1.y) + (r1.y);
    r5.y = (r3.z) * (-(r8.x)) + (r1.x);
    r3.xyz = (r10.xyz) * (-(r1.yyy)) + (r0.xyz);
    r4 = tex2D(s4, v0.xy);
    r2 = float4(((r6.w) >= 0.0f ? (r2.x) : (r4.x)), ((r6.w) >= 0.0f ? (r2.y) : (r4.y)), ((r6.w) >= 0.0f ? (r2.z) : (r4.z)), ((r6.w) >= 0.0f ? (r2.w) : (r4.w)));
    r0.z = saturate(dot(r10.xyz, -(r0.xyz)));
    r3.w = (r2.w) * (c2.w);
    r3 = texCUBElod(s15, r3);
    r0.z = (-(r0.z)) + (-(c1.y));
    r0.x = (r0.z) * (r0.z);
    r0.y = (r2.w) * (c4.z) + (c4.w);
    r0.z = (r0.z) * (r0.x);
    r0.y = 1.0f / (r0.y);
    r1.y = (r0.z) * (r0.y);
    r4.xyz = (r2.xyz) * (-(r2.xyz)) + (-(c1.yyy));
    r0.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r1.yyy) * (r4.xyz);
    r0.xyz = (r1.zzz) * (r0.xyz);
    r1.xyz = (r2.xyz) * (r2.xyz) + (r3.xyz);
    r5.y = (r5.y) + (r5.y);
    r0.xyz = (r0.xyz) * (r1.xyz);
    r1.xyz = (r5.xyz) * (r5.www) + (r7.xyz);
    r0.xyz = (r5.xyz) * (r0.xyz);
    r8.xyz = (r1.www) * (r1.xyz);
    r9.xyz = (r0.xyz) * (c2.www);
    r7 = tex2D(s0, v0.xy);
    r4 = (-(v5.yyyy)) + (c[6]);
    r1 = (r4) * (r4);
    r3 = (-(v5.xxxx)) + (c[5]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v5.zzzz)) + (c[7]);
    r1 = (r2) * (r2) + (r1);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r0.xyz = float3(((r6.w) >= 0.0f ? (r6.x) : (r7.x)), ((r6.w) >= 0.0f ? (r6.y) : (r7.y)), ((r6.w) >= 0.0f ? (r6.z) : (r7.z)));
    r4 = (r4) * (r5);
    r4 = (r10.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r10.xxxx) + (r4);
    r4.z = c1.y;
    r1 = saturate((r1) * (c[8]) + (-(r4.zzzz)));
    r2 = saturate((r2) * (r10.zzzz) + (r3));
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1 = (r1) * (r2);
    r3.xyz = (r0.xyz) * (r8.xyz) + (r9.xyz);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r2.z = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = -(c1.y);

    return oC0;
}

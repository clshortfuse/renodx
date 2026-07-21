// Mechanically reconstructed from 0xFFDA286A.ps_3_0.cso.
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
    const float4 c0 = float4(3.5f, 1.0f, 4.0f, -2.0f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(2.0f, -1.0f, -0.5f, -0.0f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 8.0f, 31.875f);
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

    r1 = tex2D(s0, v0.xy);
    r5.w = (r1.w) * (v6.x) + (c2.z);
    r0 = tex2D(s2, v6.zw);
    r2 = tex2D(s1, v0.xy);
    r3.xy = (r2.wy) * (c1.xy) + (c1.zw);
    r3.zw = c[5].xy;
    r2 = tex2D(s3, v6.zw);
    r4.xy = (r2.wy) * (c1.xy) + (c1.zw);
    r2 = (c2.xxxx) * (v7) + (c2.yyyy);
    r3 = float4(((r5.w) >= 0.0f ? (r3.x) : (c2.w)), ((r5.w) >= 0.0f ? (r3.y) : (c2.w)), ((r5.w) >= 0.0f ? (r3.z) : (c2.w)), ((r5.w) >= 0.0f ? (r3.w) : (c2.w)));
    r2.x = dot(r4.xy, r2.xy) + (c2.w);
    r2.y = dot(r4.xy, r2.zw) + (c2.w);
    r8.w = (r0.w) * (v6.y);
    r10.xy = lerp(r3.xy, r2.xy, r8.ww);
    r2 = v1;
    r2.xyz = (r10.xxx) * (v4.xyz) + (r2.xyz);
    r1 = (r1.xyzx) * (-(c2.yyyw)) + (-(c2.wwwy));
    r4.xyz = (r10.yyy) * (v3.xyz) + (r2.xyz);
    r2.xyz = normalize(r4.xyz);
    r8.xyz = normalize(v5.xyz);
    r1 = float4(((r5.w) >= 0.0f ? (r1.x) : (c2.w)), ((r5.w) >= 0.0f ? (r1.y) : (c2.w)), ((r5.w) >= 0.0f ? (r1.z) : (c2.w)), ((r5.w) >= 0.0f ? (r1.w) : (c2.w)));
    r3.y = dot(r8.xyz, r2.xyz);
    r7.xyz = lerp(r1.xyz, r0.xyz, r8.www);
    r0.z = (r3.y) + (r3.y);
    r9.xy = lerp(r3.zw, c[6].xy, r8.ww);
    r3.xyz = (r2.xyz) * (-(r0.zzz)) + (r8.xyz);
    r4 = tex2D(s4, v0.xy);
    r6 = float4(((r5.w) >= 0.0f ? (r4.x) : (-(c2.w))), ((r5.w) >= 0.0f ? (r4.y) : (-(c2.w))), ((r5.w) >= 0.0f ? (r4.z) : (-(c2.w))), ((r5.w) >= 0.0f ? (r4.w) : (-(c2.y))));
    r4 = tex2D(s5, v6.zw);
    r5 = lerp(r6, r4, r8.wwww);
    r1.z = saturate(dot(r2.xyz, -(r8.xyz)));
    r3.w = (r5.w) * (c3.z);
    r3 = texCUBElod(s15, r3);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r0.xyz = (r9.xxx) * (r0.xyz);
    r1.z = (-(r1.z)) + (-(c2.y));
    r1.x = (r1.z) * (r1.z);
    r1.y = (r5.w) * (c0.x) + (c0.y);
    r1.z = (r1.z) * (r1.x);
    r1.y = 1.0f / (r1.y);
    r2.z = (r1.z) * (r1.y);
    r1.xyz = (r5.xyz) * (-(r5.xyz)) + (-(c2.yyy));
    r1.xyz = (r2.zzz) * (r1.xyz);
    r2.xy = (v0.zw) * (-(c2.yz));
    r3 = tex2D(s13, r2.xy);
    r4 = tex2D(s14, v0.zw);
    r6.xy = (r4.xy) * (c3.ww);
    r1.xyz = (r5.xyz) * (r5.xyz) + (r1.xyz);
    r5.xy = (r3.xz) * (r6.xx);
    r2.xyz = (r0.xyz) * (r1.xyz);
    r0.z = (r4.x) * (c3.w) + (-(r5.x));
    r1.xz = (r5.xy) * (c0.zz);
    r0.z = (r3.z) * (-(r6.x)) + (r0.z);
    r0.x = r3.y;
    r3.xy = (v0.zw) * (-(c2.yz)) + (-(c2.wz));
    r3 = tex2D(s13, r3.xy);
    r5.xy = (r6.yy) * (r3.xz);
    r1.y = (r0.z) + (r0.z);
    r0.z = (r4.y) * (c3.w) + (-(r5.x));
    r4.xz = (r5.xy) * (c0.zz);
    r0.y = r3.y;
    r3.z = (r3.z) * (-(r6.y)) + (r0.z);
    r0.xy = (r0.xy) * (c0.zz) + (c0.ww);
    r3.w = dot(r0.xy, r0.xy) + (c2.w);
    r0.z = dot(r10.xy, r10.xy) + (c2.w);
    r3.w = exp2(-(r3.w));
    r0.z = exp2(-(r0.z));
    r3.y = (r3.w) * (c3.x) + (c3.y);
    r3.w = (r0.z) * (c3.x) + (c3.y);
    r0.z = dot(r0.xy, r10.xy) + (c2.w);
    r0.y = (r3.y) * (r3.w);
    r4.y = (r3.z) + (r3.z);
    r0.z = saturate((r0.z) * (r0.y) + (r0.y));
    r2.xyz = (r2.xyz) * (r1.xyz);
    r0.xyz = (r4.xyz) * (r0.zzz);
    r2.xyz = (r2.xyz) * (c3.zzz);
    r0.xyz = (r1.xyz) * (r3.www) + (r0.xyz);
    r1.xyz = (r9.yyy) * (r0.xyz);
    r0.xyz = (r7.xyz) * (r7.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r2.www) * (r0.xyz) + (v2.xyz);
    r1.w = (-(r1.w)) + (-(c2.y));
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = (r0.w) * (-(v6.y)) + (-(c2.y));
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r1.w) * (-(r0.w)) + (-(c2.y));
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}

// Mechanically reconstructed from 0x5ED7819E.ps_3_0.cso.
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
    const float4 c1 = float4(2.0f, -1.0f, -0.5f, -0.0f);
    const float4 c2 = float4(0.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 3.5f, 1.0f);
    const float4 c4 = float4(31.875f, 4.0f, -2.0f, 0.0f);
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

    r0 = tex2D(s0, v0.xy);
    r4 = (r0.xyzx) * (-(c1.yyyw)) + (-(c1.wwwy));
    r5.w = (r0.w) * (v6.x) + (c1.z);
    r0 = tex2D(s2, v6.zw);
    r1 = tex2D(s1, v0.xy);
    r1.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1.zw = c[5].xy;
    r6.w = (r0.w) * (v6.y) + (c1.z);
    r2 = float4(((r5.w) >= 0.0f ? (r1.x) : (c1.w)), ((r5.w) >= 0.0f ? (r1.y) : (c1.w)), ((r5.w) >= 0.0f ? (r1.z) : (c1.w)), ((r5.w) >= 0.0f ? (r1.w) : (c1.w)));
    r1 = tex2D(s3, v6.zw);
    r3.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1 = (c1.xxxx) * (v7) + (c1.yyyy);
    r1.x = dot(r3.xy, r1.xy) + (c1.w);
    r1.y = dot(r3.xy, r1.zw) + (c1.w);
    r3 = tex2D(s5, v6.zw);
    r1.zw = r3.yy;
    r4 = float4(((r5.w) >= 0.0f ? (r4.x) : (c1.w)), ((r5.w) >= 0.0f ? (r4.y) : (c1.w)), ((r5.w) >= 0.0f ? (r4.z) : (c1.w)), ((r5.w) >= 0.0f ? (r4.w) : (c1.w)));
    r2 = float4(((r6.w) >= 0.0f ? (r1.x) : (r2.x)), ((r6.w) >= 0.0f ? (r1.y) : (r2.y)), ((r6.w) >= 0.0f ? (r1.z) : (r2.z)), ((r6.w) >= 0.0f ? (r1.w) : (r2.w)));
    r0 = (r0.xyzx) * (-(c1.yyyw)) + (-(c1.wwwy));
    r1 = v1;
    r1.xyz = (r2.xxx) * (v4.xyz) + (r1.xyz);
    r0 = float4(((r6.w) >= 0.0f ? (r0.x) : (r4.x)), ((r6.w) >= 0.0f ? (r0.y) : (r4.y)), ((r6.w) >= 0.0f ? (r0.z) : (r4.z)), ((r6.w) >= 0.0f ? (r0.w) : (r4.w)));
    r1.xyz = (r2.yyy) * (v3.xyz) + (r1.xyz);
    r6.xyz = normalize(r1.xyz);
    r7.xyz = normalize(v5.xyz);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.z = dot(r7.xyz, r6.xyz);
    r3 = (r3.wwww) * (c2.xxxy) + (c2.zzzx);
    r0.z = (r0.z) + (r0.z);
    r4 = tex2D(s4, v0.xy);
    r5 = float4(((r5.w) >= 0.0f ? (r4.x) : (-(c1.w))), ((r5.w) >= 0.0f ? (r4.y) : (-(c1.w))), ((r5.w) >= 0.0f ? (r4.z) : (-(c1.w))), ((r5.w) >= 0.0f ? (r4.w) : (-(c1.y))));
    r4.xyz = (r6.xyz) * (-(r0.zzz)) + (r7.xyz);
    r3 = float4(((r6.w) >= 0.0f ? (r3.x) : (r5.x)), ((r6.w) >= 0.0f ? (r3.y) : (r5.y)), ((r6.w) >= 0.0f ? (r3.z) : (r5.z)), ((r6.w) >= 0.0f ? (r3.w) : (r5.w)));
    r5.w = saturate(dot(r6.xyz, -(r7.xyz)));
    r4.w = (r3.w) * (c2.w);
    r4 = texCUBElod(s15, r4);
    r0.xyz = (r4.xyz) * (r4.xyz);
    r4.z = (-(r5.w)) + (-(c1.y));
    r4.y = (r4.z) * (r4.z);
    r4.w = (r3.w) * (c3.z) + (c3.w);
    r3.w = (r4.z) * (r4.y);
    r4.w = 1.0f / (r4.w);
    r3.w = (r3.w) * (r4.w);
    r4.xyz = (r3.xyz) * (-(r3.xyz)) + (-(c1.yyy));
    r0.xyz = (r2.zzz) * (r0.xyz);
    r4.xyz = (r3.www) * (r4.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz) + (r4.xyz);
    r4.xy = (v0.zw) * (-(c1.yz));
    r5 = tex2D(s13, r4.xy);
    r4 = tex2D(s14, v0.zw);
    r7.xy = (r4.xy) * (c4.xx);
    r6.xyz = (r0.xyz) * (r3.xyz);
    r0.xy = (r5.xz) * (r7.xx);
    r0.z = (r4.x) * (c4.x) + (-(r0.x));
    r4.xz = (r0.xy) * (c4.yy);
    r2.z = (r5.z) * (-(r7.x)) + (r0.z);
    r0.xy = (v0.zw) * (-(c1.yz)) + (-(c1.wz));
    r3 = tex2D(s13, r0.xy);
    r8.xy = (r7.yy) * (r3.xz);
    r0.x = r5.y;
    r0.z = (r4.y) * (c4.x) + (-(r8.x));
    r5.xz = (r8.xy) * (c4.yy);
    r0.y = r3.y;
    r3.z = (r3.z) * (-(r7.y)) + (r0.z);
    r0.xy = (r0.xy) * (c4.yy) + (c4.zz);
    r3.w = dot(r0.xy, r0.xy) + (c1.w);
    r0.z = dot(r2.xy, r2.xy) + (c1.w);
    r3.w = exp2(-(r3.w));
    r0.z = exp2(-(r0.z));
    r3.y = (r3.w) * (c3.x) + (c3.y);
    r3.w = (r0.z) * (c3.x) + (c3.y);
    r0.z = dot(r0.xy, r2.xy) + (c1.w);
    r0.y = (r3.y) * (r3.w);
    r5.y = (r3.z) + (r3.z);
    r0.z = saturate((r0.z) * (r0.y) + (r0.y));
    r4.y = (r2.z) + (r2.z);
    r0.xyz = (r5.xyz) * (r0.zzz);
    r2.xyz = (r6.xyz) * (r4.xyz);
    r0.xyz = (r4.xyz) * (r3.www) + (r0.xyz);
    r2.xyz = (r2.xyz) * (c2.www);
    r0.xyz = (r2.www) * (r0.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (c[6].w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}

// Mechanically reconstructed from 0x1662D982.ps_3_0.cso.
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

    r0 = tex2D(s1, v0.xy);
    r0.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.zw = c[5].xy;
    r4 = tex2D(s0, v0.xy);
    r7.z = (r4.w) * (v6.x) + (c1.z);
    r2 = float4(((r7.z) >= 0.0f ? (r0.x) : (c1.w)), ((r7.z) >= 0.0f ? (r0.y) : (c1.w)), ((r7.z) >= 0.0f ? (r0.z) : (c1.w)), ((r7.z) >= 0.0f ? (r0.w) : (c1.w)));
    r0 = tex2D(s3, v6.zw);
    r3.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = (c1.xxxx) * (v7) + (c1.yyyy);
    r1.x = dot(r3.xy, r0.xy) + (c1.w);
    r1.y = dot(r3.xy, r0.zw) + (c1.w);
    r3 = tex2D(s5, v6.zw);
    r1.zw = r3.yy;
    r0 = tex2D(s2, v6.zw);
    r7.w = (r0.w) * (v6.y) + (c1.z);
    r2 = float4(((r7.w) >= 0.0f ? (r1.x) : (r2.x)), ((r7.w) >= 0.0f ? (r1.y) : (r2.y)), ((r7.w) >= 0.0f ? (r1.z) : (r2.z)), ((r7.w) >= 0.0f ? (r1.w) : (r2.w)));
    r1 = v1;
    r1.xyz = (r2.xxx) * (v4.xyz) + (r1.xyz);
    r3.xyz = (r2.yyy) * (v3.xyz) + (r1.xyz);
    r1.xyz = normalize(r3.xyz);
    r6.xyz = normalize(v5.xyz);
    r4 = (r4.xyzx) * (-(c1.yyyw)) + (-(c1.wwwy));
    r0.w = saturate(dot(r1.xyz, -(r6.xyz)));
    r3 = (r3.wwww) * (c2.xxxy) + (c2.zzzx);
    r6.w = (-(r0.w)) + (-(c1.y));
    r0 = (r0.xyzx) * (-(c1.yyyw)) + (-(c1.wwwy));
    r7.y = (r6.w) * (r6.w);
    r5 = tex2D(s4, v0.xy);
    r5 = float4(((r7.z) >= 0.0f ? (r5.x) : (-(c1.w))), ((r7.z) >= 0.0f ? (r5.y) : (-(c1.w))), ((r7.z) >= 0.0f ? (r5.z) : (-(c1.w))), ((r7.z) >= 0.0f ? (r5.w) : (-(c1.y))));
    r6.w = (r6.w) * (r7.y);
    r3 = float4(((r7.w) >= 0.0f ? (r3.x) : (r5.x)), ((r7.w) >= 0.0f ? (r3.y) : (r5.y)), ((r7.w) >= 0.0f ? (r3.z) : (r5.z)), ((r7.w) >= 0.0f ? (r3.w) : (r5.w)));
    r4 = float4(((r7.z) >= 0.0f ? (r4.x) : (c1.w)), ((r7.z) >= 0.0f ? (r4.y) : (c1.w)), ((r7.z) >= 0.0f ? (r4.z) : (c1.w)), ((r7.z) >= 0.0f ? (r4.w) : (c1.w)));
    r5.w = (r3.w) * (c3.z) + (c3.w);
    r0 = float4(((r7.w) >= 0.0f ? (r0.x) : (r4.x)), ((r7.w) >= 0.0f ? (r0.y) : (r4.y)), ((r7.w) >= 0.0f ? (r0.z) : (r4.z)), ((r7.w) >= 0.0f ? (r0.w) : (r4.w)));
    r4.w = 1.0f / (r5.w);
    r4.w = (r6.w) * (r4.w);
    r4.xyz = (r3.xyz) * (-(r3.xyz)) + (-(c1.yyy));
    r4.xyz = (r4.www) * (r4.xyz);
    r4.w = dot(r6.xyz, r1.xyz);
    r5.xyz = (r3.xyz) * (r3.xyz) + (r4.xyz);
    r3.z = (r4.w) + (r4.w);
    r3.w = (r3.w) * (c2.w);
    r3.xyz = (r1.xyz) * (-(r3.zzz)) + (r6.xyz);
    r3 = texCUBElod(s15, r3);
    r1.xyz = (r3.xyz) * (r3.xyz);
    r3.xy = (v0.zw) * (-(c1.yz));
    r3 = tex2D(s13, r3.xy);
    r4 = tex2D(s14, v0.zw);
    r7.xy = (r4.xy) * (c4.xx);
    r1.xyz = (r2.zzz) * (r1.xyz);
    r8.xy = (r3.xz) * (r7.xx);
    r6.xyz = (r5.xyz) * (r1.xyz);
    r1.z = (r4.x) * (c4.x) + (-(r8.x));
    r5.xz = (r8.xy) * (c4.yy);
    r1.z = (r3.z) * (-(r7.x)) + (r1.z);
    r1.x = r3.y;
    r3.xy = (v0.zw) * (-(c1.yz)) + (-(c1.wz));
    r3 = tex2D(s13, r3.xy);
    r8.xy = (r7.yy) * (r3.xz);
    r5.y = (r1.z) + (r1.z);
    r1.z = (r4.y) * (c4.x) + (-(r8.x));
    r4.xz = (r8.xy) * (c4.yy);
    r1.y = r3.y;
    r2.z = (r3.z) * (-(r7.y)) + (r1.z);
    r1.xy = (r1.xy) * (c4.yy) + (c4.zz);
    r3.w = dot(r1.xy, r1.xy) + (c1.w);
    r1.z = dot(r2.xy, r2.xy) + (c1.w);
    r3.w = exp2(-(r3.w));
    r1.z = exp2(-(r1.z));
    r3.z = (r3.w) * (c3.x) + (c3.y);
    r3.w = (r1.z) * (c3.x) + (c3.y);
    r1.z = dot(r1.xy, r2.xy) + (c1.w);
    r1.y = (r3.z) * (r3.w);
    r4.y = (r2.z) + (r2.z);
    r1.z = saturate((r1.z) * (r1.y) + (r1.y));
    r2.xyz = (r6.xyz) * (r5.xyz);
    r1.xyz = (r4.xyz) * (r1.zzz);
    r2.xyz = (r2.xyz) * (c2.www);
    r1.xyz = (r5.xyz) * (r3.www) + (r1.xyz);
    r1.xyz = (r2.www) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}

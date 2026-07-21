// Mechanically reconstructed from 0xAB09AA0A.ps_3_0.cso.
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
    float4 r9 = 0.0f;
    float4 r10 = 0.0f;
    float4 oC0 = 0.0f;

    r1 = tex2D(s0, v0.xy);
    r0 = (r1.xyzx) * (-(c1.yyyw)) + (-(c1.wwwy));
    r3.w = (r1.w) * (v6.x) + (c1.z);
    r1 = float4(((r3.w) >= 0.0f ? (r0.x) : (c1.w)), ((r3.w) >= 0.0f ? (r0.y) : (c1.w)), ((r3.w) >= 0.0f ? (r0.z) : (c1.w)), ((r3.w) >= 0.0f ? (r0.w) : (c1.w)));
    r0 = tex2D(s2, v6.zw);
    r2 = tex2D(s1, v0.xy);
    r3.xy = (r2.wy) * (c0.xy) + (c0.zw);
    r2 = tex2D(s4, v0.xy);
    r3.z = r2.y;
    r2 = (r2.wwww) * (c2.xxxy) + (c2.zzzx);
    r6.xyz = float3(((r3.w) >= 0.0f ? (r3.x) : (c1.w)), ((r3.w) >= 0.0f ? (r3.y) : (c1.w)), ((r3.w) >= 0.0f ? (r3.z) : (c1.w)));
    r5 = float4(((r3.w) >= 0.0f ? (r2.x) : (-(c1.w))), ((r3.w) >= 0.0f ? (r2.y) : (-(c1.w))), ((r3.w) >= 0.0f ? (r2.z) : (-(c1.w))), ((r3.w) >= 0.0f ? (r2.w) : (-(c1.y))));
    r2 = tex2D(s3, v6.zw);
    r4.xy = (r2.wy) * (c0.xy) + (c0.zw);
    r2 = (c1.xxxx) * (v7) + (c1.yyyy);
    r3.x = dot(r4.xy, r2.xy) + (c1.w);
    r3.y = dot(r4.xy, r2.zw) + (c1.w);
    r6.w = (r0.w) * (v6.y);
    r2.xy = (v0.zw) * (-(c1.yz));
    r2 = tex2D(s13, r2.xy);
    r4.xy = (v0.zw) * (-(c1.yz)) + (-(c1.wz));
    r4 = tex2D(s13, r4.xy);
    r2.w = r4.y;
    r10.xy = lerp(r6.xy, r3.xy, r6.ww);
    r3.xy = (r2.yw) * (c4.yy) + (c4.zz);
    r2.w = dot(r10.xy, r10.xy) + (c1.w);
    r2.y = dot(r3.xy, r3.xy) + (c1.w);
    r2.w = exp2(-(r2.w));
    r2.y = exp2(-(r2.y));
    r2.w = (r2.w) * (c3.x) + (c3.y);
    r3.w = (r2.y) * (c3.x) + (c3.y);
    r2.y = dot(r3.xy, r10.xy) + (c1.w);
    r4.w = (r2.w) * (r3.w);
    r3 = tex2D(s14, v0.zw);
    r6.xy = (r3.xy) * (c4.xx);
    r3.z = saturate((r2.y) * (r4.w) + (r4.w));
    r4.xy = (r4.xz) * (r6.yy);
    r2.y = (r3.y) * (c4.x) + (-(r4.x));
    r7.xz = (r4.xy) * (c4.yy);
    r3.w = (r4.z) * (-(r6.y)) + (r2.y);
    r2.xy = (r2.xz) * (r6.xx);
    r7.y = (r3.w) + (r3.w);
    r3.w = (r3.x) * (c4.x) + (-(r2.x));
    r3.xyz = (r3.zzz) * (r7.xyz);
    r2.z = (r2.z) * (-(r6.x)) + (r3.w);
    r7.xz = (r2.xy) * (c4.yy);
    r7.y = (r2.z) + (r2.z);
    r9.xy = lerp(r6.zz, c[20].xy, r6.ww);
    r2.xyz = (r7.xyz) * (r2.www) + (r3.xyz);
    r8.xyz = lerp(r1.xyz, r0.xyz, r6.www);
    r1.xyz = (r9.yyy) * (r2.xyz);
    r4 = tex2D(s5, v6.zw);
    r2 = v1;
    r0.xyz = (r10.xxx) * (v4.xyz) + (r2.xyz);
    r2.xyz = (r10.yyy) * (v3.xyz) + (r0.xyz);
    r0.xyz = normalize(r2.xyz);
    r2.xyz = normalize(v5.xyz);
    r3 = lerp(r5, r4, r6.wwww);
    r4.z = dot(r2.xyz, r0.xyz);
    r4.w = (r3.w) * (c2.w);
    r4.z = (r4.z) + (r4.z);
    r4.xyz = (r0.xyz) * (-(r4.zzz)) + (r2.xyz);
    r5.w = saturate(dot(r0.xyz, -(r2.xyz)));
    r4 = texCUBElod(s15, r4);
    r2.xyz = (r4.xyz) * (r4.xyz);
    r4.z = (-(r5.w)) + (-(c1.y));
    r4.y = (r4.z) * (r4.z);
    r4.w = (r3.w) * (c3.z) + (c3.w);
    r3.w = (r4.z) * (r4.y);
    r4.w = 1.0f / (r4.w);
    r3.w = (r3.w) * (r4.w);
    r4.xyz = (r3.xyz) * (-(r3.xyz)) + (-(c1.yyy));
    r2.xyz = (r9.xxx) * (r2.xyz);
    r4.xyz = (r3.www) * (r4.xyz);
    r9.xyz = (r3.xyz) * (r3.xyz) + (r4.xyz);
    r6 = (-(v5.yyyy)) + (c[6]);
    r3 = (r6) * (r6);
    r5 = (-(v5.xxxx)) + (c[5]);
    r3 = (r5) * (r5) + (r3);
    r4 = (-(v5.zzzz)) + (c[7]);
    r2.xyz = (r2.xyz) * (r9.xyz);
    r3 = (r4) * (r4) + (r3);
    r2.xyz = (r7.xyz) * (r2.xyz);
    r7.x = rsqrt(r3.x);
    r7.y = rsqrt(r3.y);
    r7.z = rsqrt(r3.z);
    r7.w = rsqrt(r3.w);
    r2.xyz = (r2.xyz) * (c2.www);
    r6 = (r6) * (r7);
    r6 = (r0.yyyy) * (r6);
    r5 = (r5) * (r7);
    r4 = (r4) * (r7);
    r5 = (r5) * (r0.xxxx) + (r6);
    r0.y = c1.y;
    r3 = saturate((r3) * (c[8]) + (-(r0.yyyy)));
    r4 = saturate((r4) * (r0.zzzz) + (r5));
    r0.xyz = (r8.xyz) * (r8.xyz);
    r3 = (r3) * (r4);
    r2.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r1.x = dot(c[9], r3);
    r1.y = dot(c[10], r3);
    r1.z = dot(c[11], r3);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r2.www) * (r0.xyz) + (v2.xyz);
    r1.w = (-(r1.w)) + (-(c1.y));
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = (r0.w) * (-(v6.y)) + (-(c1.y));
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r1.w) * (-(r0.w)) + (-(c1.y));
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}

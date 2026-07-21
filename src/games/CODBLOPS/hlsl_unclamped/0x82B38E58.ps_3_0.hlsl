// Mechanically reconstructed from 0x82B38E58.ps_3_0.cso.
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
    const float4 c1 = float4(-1.0f, 1.0f, 0.200000003f, -0.5f);
    const float4 c2 = float4(0.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c4 = float4(4.0f, -2.0f, 0.0f, 0.0f);
    const float4 c7 = float4(0.600000024f, 0.400000006f, 3.5f, 1.0f);
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

    r0 = tex2D(s1, v1.xy);
    r9.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = v2;
    r0.xyz = (r9.xxx) * (v5.xyz) + (r0.xyz);
    r1.xyz = (r9.yyy) * (v4.xyz) + (r0.xyz);
    r0.xyz = normalize(r1.xyz);
    r8.xyz = normalize(v6.xyz);
    r1 = tex2D(s2, v7.xy);
    r1.xyz = (r1.xyz) + (c1.xxx);
    r1.w = dot(r8.xyz, r0.xyz);
    r7.xyz = (v0.yyy) * (r1.xyz) + (c1.yyy);
    r5.w = (r1.w) + (r1.w);
    r6.xyz = (r7.xyz) * (c1.zzz);
    r3 = tex2D(s5, v7.zw);
    r2 = (r3.wwww) * (c2.xxxy) + (c2.zzzx);
    r4 = tex2D(s4, v1.xy);
    r6.w = r4.w;
    r1 = tex2D(s3, v7.zw);
    r4.w = (r1.w) * (v0.z) + (c1.w);
    r5.xyz = (r0.xyz) * (-(r5.www)) + (r8.xyz);
    r2 = float4(((r4.w) >= 0.0f ? (r2.x) : (r6.x)), ((r4.w) >= 0.0f ? (r2.y) : (r6.y)), ((r4.w) >= 0.0f ? (r2.z) : (r6.z)), ((r4.w) >= 0.0f ? (r2.w) : (r6.w)));
    r3.w = saturate(dot(r0.xyz, -(r8.xyz)));
    r5.w = (r2.w) * (c2.w);
    r5 = texCUBElod(s15, r5);
    r0.xyz = (r5.xyz) * (r5.xyz);
    r1.w = ((r4.w) >= 0.0f ? (r3.y) : (r4.y));
    r3.z = (-(r3.w)) + (c1.y);
    r3.y = (r3.z) * (r3.z);
    r3.w = (r2.w) * (c7.z) + (c7.w);
    r2.w = (r3.z) * (r3.y);
    r3.w = 1.0f / (r3.w);
    r2.w = (r2.w) * (r3.w);
    r3.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.yyy);
    r0.xyz = (r0.xyz) * (r1.www);
    r3.xyz = (r2.www) * (r3.xyz);
    r4.xyz = (r2.xyz) * (r2.xyz) + (r3.xyz);
    r2.xy = (v1.zw) * (-(c1.xw));
    r2 = tex2D(s13, r2.xy);
    r3 = tex2D(s14, v1.zw);
    r8.xy = (r3.xy) * (c3.ww);
    r5.xyz = (r0.xyz) * (r4.xyz);
    r0.xy = (r2.xz) * (r8.xx);
    r0.z = (r3.x) * (c3.w) + (-(r0.x));
    r4.xz = (r0.xy) * (c4.xx);
    r0.z = (r2.z) * (-(r8.x)) + (r0.z);
    r0.x = r2.y;
    r4.y = (r0.z) + (r0.z);
    r2.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r2 = tex2D(s13, r2.xy);
    r10.xy = (r8.yy) * (r2.xz);
    r6.xyz = (r5.xyz) * (r4.xyz);
    r0.z = (r3.y) * (c3.w) + (-(r10.x));
    r5.xz = (r10.xy) * (c4.xx);
    r0.y = r2.y;
    r2.w = (r2.z) * (-(r8.y)) + (r0.z);
    r0.xy = (r0.xy) * (c4.xx) + (c4.yy);
    r2.z = dot(r0.xy, r0.xy) + (c2.x);
    r0.z = dot(r9.xy, r9.xy) + (c2.x);
    r2.z = exp2(-(r2.z));
    r0.z = exp2(-(r0.z));
    r2.z = (r2.z) * (c7.x) + (c7.y);
    r3.w = (r0.z) * (c7.x) + (c7.y);
    r0.z = dot(r0.xy, r9.xy) + (c2.x);
    r0.y = (r2.z) * (r3.w);
    r5.y = (r2.w) + (r2.w);
    r0.z = saturate((r0.z) * (r0.y) + (r0.y));
    r3.xyz = (r6.xyz) * (c2.www);
    r5.xyz = (r5.xyz) * (r0.zzz);
    r2 = tex2D(s0, v1.xy);
    r0.xyz = (r7.xyz) * (r2.xyz);
    r2.xyz = (r4.xyz) * (r3.www) + (r5.xyz);
    r0.xyz = float3(((r4.w) >= 0.0f ? (r1.x) : (r0.x)), ((r4.w) >= 0.0f ? (r1.y) : (r0.y)), ((r4.w) >= 0.0f ? (r1.z) : (r0.z)));
    r1.xyz = (r1.www) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[5].w;

    return oC0;
}

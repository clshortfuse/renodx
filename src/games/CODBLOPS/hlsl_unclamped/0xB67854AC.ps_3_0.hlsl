// Mechanically reconstructed from 0xB67854AC.ps_3_0.cso.
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
    const float4 c1 = float4(-0.5f, 1.0f, -1.0f, 0.200000003f);
    const float4 c2 = float4(0.0f, 0.600000024f, 0.400000006f, 8.0f);
    const float4 c3 = float4(31.875f, 4.0f, -2.0f, 0.0f);
    const float4 c4 = float4(3.5f, 1.0f, 0.5f, 0.0f);
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

    r0.xy = (v1.zw) * (-(c1.zx));
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c4.yz) + (c4.wz);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r3.xy = (r0.yw) * (c3.yy) + (c3.zz);
    r1 = tex2D(s1, v1.xy);
    r6.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r0.w = dot(r3.xy, r3.xy) + (c2.x);
    r0.y = dot(r6.xy, r6.xy) + (c2.x);
    r0.w = exp2(-(r0.w));
    r0.y = exp2(-(r0.y));
    r0.w = (r0.w) * (c2.y) + (c2.z);
    r4.w = (r0.y) * (c2.y) + (c2.z);
    r0.y = (r0.w) * (r4.w);
    r1 = tex2D(s14, v1.zw);
    r5.xy = (r1.xy) * (c3.xx);
    r0.w = dot(r3.xy, r6.xy) + (c2.x);
    r2.xy = (r2.xz) * (r5.yy);
    r0.w = saturate((r0.w) * (r0.y) + (r0.y));
    r0.y = (r1.y) * (c3.x) + (-(r2.x));
    r3.xz = (r2.xy) * (c3.yy);
    r0.y = (r2.z) * (-(r5.y)) + (r0.y);
    r3.y = (r0.y) + (r0.y);
    r0.xy = (r0.xz) * (r5.xx);
    r4.xyz = (r0.www) * (r3.xyz);
    r0.w = (r1.x) * (c3.x) + (-(r0.x));
    r3.xz = (r0.xy) * (c3.yy);
    r3.y = (r0.z) * (-(r5.x)) + (r0.w);
    r5 = tex2D(s2, v7.xy);
    r5.w = (r5.w) * (v0.y) + (c1.x);
    r2 = tex2D(s4, v1.xy);
    r0 = v2;
    r0.xyz = (r6.xxx) * (v5.xyz) + (r0.xyz);
    r3.w = ((r5.w) >= 0.0f ? (c1.y) : (r2.y));
    r0.xyz = (r6.yyy) * (v4.xyz) + (r0.xyz);
    r9.xyz = normalize(r0.xyz);
    r0.xyz = normalize(v6.xyz);
    r1.w = (r2.w) * (c2.w);
    r1.z = dot(r0.xyz, r9.xyz);
    r2.w = (r2.w) * (c4.x) + (c4.y);
    r1.z = (r1.z) + (r1.z);
    r1.xyz = (r9.xyz) * (-(r1.zzz)) + (r0.xyz);
    r0.z = saturate(dot(r9.xyz, -(r0.xyz)));
    r1 = texCUBElod(s15, r1);
    r1.w = 1.0f / (r2.w);
    r6.w = (-(r0.z)) + (c1.y);
    r2 = tex2D(s3, v7.zw);
    r0.xyz = (r2.xyz) + (c1.zzz);
    r2.w = (r6.w) * (r6.w);
    r10.xyz = (v0.zzz) * (r0.xyz) + (c1.yyy);
    r0.z = (r6.w) * (r2.w);
    r2.xyz = (r10.xyz) * (c1.www);
    r1.w = (r1.w) * (r0.z);
    r6.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.yyy);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r1.www) * (r6.xyz);
    r0.xyz = (r3.www) * (r0.xyz);
    r1.xyz = (r2.xyz) * (r2.xyz) + (r1.xyz);
    r3.y = (r3.y) + (r3.y);
    r0.xyz = (r0.xyz) * (r1.xyz);
    r1.xyz = (r3.xyz) * (r4.www) + (r4.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r7.xyz = (r3.www) * (r1.xyz);
    r8.xyz = (r0.xyz) * (c2.www);
    r6 = tex2D(s0, v1.xy);
    r4 = (-(v6.yyyy)) + (c[6]);
    r1 = (r4) * (r4);
    r3 = (-(v6.xxxx)) + (c[5]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v6.zzzz)) + (c[7]);
    r1 = (r2) * (r2) + (r1);
    r0.xyz = float3(((r5.w) >= 0.0f ? (r5.x) : (r6.x)), ((r5.w) >= 0.0f ? (r5.y) : (r6.y)), ((r5.w) >= 0.0f ? (r5.z) : (r6.z)));
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r0.xyz = (r10.xyz) * (r0.xyz);
    r4 = (r4) * (r5);
    r4 = (r9.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r9.xxxx) + (r4);
    r4.z = c1.y;
    r1 = saturate((r1) * (c[8]) + (r4.zzzz));
    r2 = saturate((r2) * (r9.zzzz) + (r3));
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1 = (r1) * (r2);
    r3.xyz = (r0.xyz) * (r7.xyz) + (r8.xyz);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r2.z = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
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

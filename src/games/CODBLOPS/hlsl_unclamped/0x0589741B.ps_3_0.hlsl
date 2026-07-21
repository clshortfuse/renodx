// Mechanically reconstructed from 0x0589741B.ps_3_0.cso.
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
sampler2D s6 : register(s6);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
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
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(2.0f, -1.0f, -0.5f, 1.0f);
    const float4 c3 = float4(0.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c11 = float4(4.0f, -2.0f, 0.0f, 0.0f);
    const float4 c12 = float4(0.600000024f, 0.400000006f, 3.5f, 1.0f);
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

    r0.xy = (v1.zw) * (-(c2.yz));
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c4.xy) + (c4.zy);
    r6 = tex2D(s13, r0.xy);
    r2.w = r6.y;
    r0 = tex2D(s1, v1.xy);
    r5.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = tex2D(s4, v6.zw);
    r7.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c2.xxxx) * (v7) + (c2.yyyy);
    r3.zw = c[8].xy;
    r3.x = dot(r7.xy, r0.xy) + (c3.x);
    r4 = tex2D(s5, v1.xy);
    r1 = tex2D(s2, v6.xy);
    r6.w = (r1.w) * (v0.y) + (c2.z);
    r3.y = dot(r7.xy, r0.zw) + (c3.x);
    r5.zw = float2(((r6.w) >= 0.0f ? (c2.w) : (r4.y)), ((r6.w) >= 0.0f ? (c2.w) : (r4.y)));
    r0 = tex2D(s3, v6.zw);
    r1.w = (r0.w) * (v0.z) + (c2.z);
    r7.xy = (r2.yw) * (c11.xx) + (c11.yy);
    r3 = float4(((r1.w) >= 0.0f ? (r3.x) : (r5.x)), ((r1.w) >= 0.0f ? (r3.y) : (r5.y)), ((r1.w) >= 0.0f ? (r3.z) : (r5.z)), ((r1.w) >= 0.0f ? (r3.w) : (r5.w)));
    r0.w = dot(r7.xy, r7.xy) + (c3.x);
    r2.w = dot(r3.xy, r3.xy) + (c3.x);
    r0.w = exp2(-(r0.w));
    r2.w = exp2(-(r2.w));
    r0.w = (r0.w) * (c12.x) + (c12.y);
    r2.w = (r2.w) * (c12.x) + (c12.y);
    r5 = (r4.wwww) * (c3.xxxy) + (c3.zzzx);
    r2.y = (r0.w) * (r2.w);
    r4 = tex2D(s14, v1.zw);
    r8.xy = (r4.xy) * (c4.ww);
    r0.w = dot(r7.xy, r3.xy) + (c3.x);
    r6.xy = (r6.xz) * (r8.yy);
    r0.w = saturate((r0.w) * (r2.y) + (r2.y));
    r2.y = (r4.y) * (c4.w) + (-(r6.x));
    r7.xz = (r6.xy) * (c11.xx);
    r2.y = (r6.z) * (-(r8.y)) + (r2.y);
    r7.y = (r2.y) + (r2.y);
    r2.xy = (r2.xz) * (r8.xx);
    r6.xyz = (r0.www) * (r7.xyz);
    r0.w = (r4.x) * (c4.w) + (-(r2.x));
    r7.xz = (r2.xy) * (c11.xx);
    r4.xyz = v2.xyz;
    r4.xyz = (r3.xxx) * (v4.xyz) + (r4.xyz);
    r0.w = (r2.z) * (-(r8.x)) + (r0.w);
    r2.xyz = (r3.yyy) * (v3.xyz) + (r4.xyz);
    r9.xyz = normalize(r2.xyz);
    r8.xyz = normalize(v5.xyz);
    r7.y = (r0.w) + (r0.w);
    r0.w = dot(r8.xyz, r9.xyz);
    r2.xyz = (r7.xyz) * (r2.www) + (r6.xyz);
    r0.w = (r0.w) + (r0.w);
    r6.xyz = (r3.www) * (r2.xyz);
    r4.xyz = (r9.xyz) * (-(r0.www)) + (r8.xyz);
    r2 = tex2D(s6, v6.zw);
    r2 = float4(((r1.w) >= 0.0f ? (r2.x) : (r5.x)), ((r1.w) >= 0.0f ? (r2.y) : (r5.y)), ((r1.w) >= 0.0f ? (r2.z) : (r5.z)), ((r1.w) >= 0.0f ? (r2.w) : (r5.w)));
    r0.w = saturate(dot(r9.xyz, -(r8.xyz)));
    r4.w = (r2.w) * (c3.w);
    r4 = texCUBElod(s15, r4);
    r0.w = (-(r0.w)) + (c2.w);
    r3.w = (r0.w) * (r0.w);
    r2.w = (r2.w) * (c12.z) + (c12.w);
    r0.w = (r0.w) * (r3.w);
    r2.w = 1.0f / (r2.w);
    r0.w = (r0.w) * (r2.w);
    r9.xyz = (r2.xyz) * (-(r2.xyz)) + (c2.www);
    r5.xyz = (r4.xyz) * (r4.xyz);
    r4.xyz = (r0.www) * (r9.xyz);
    r3.xyz = (r3.zzz) * (r5.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz) + (r4.xyz);
    r0.w = dot(c[5].xyz, r8.xyz);
    r3.xyz = (r3.xyz) * (r2.xyz);
    r2 = tex2D(s0, v1.xy);
    r2.xyz = float3(((r6.w) >= 0.0f ? (r1.x) : (r2.x)), ((r6.w) >= 0.0f ? (r1.y) : (r2.y)), ((r6.w) >= 0.0f ? (r1.z) : (r2.z)));
    r1.xyz = (r7.xyz) * (r3.xyz);
    r0.xyz = float3(((r1.w) >= 0.0f ? (r0.x) : (r2.x)), ((r1.w) >= 0.0f ? (r0.y) : (r2.y)), ((r1.w) >= 0.0f ? (r0.z) : (r2.z)));
    r2.xyz = (r1.xyz) * (c3.www);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.w = saturate((c[7].y) * (r0.w) + (c[7].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[6].xyz);
    r1.xyz = (r1.xyz) * (r6.xyz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[10].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[9].w;

    return oC0;
}

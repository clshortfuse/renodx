// Mechanically reconstructed from 0xF600DB09.ps_3_0.cso.
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
    const float4 c2 = float4(0.0f, -0.5f, 1.0f, 0.200000003f);
    const float4 c3 = float4(2.0f, -1.0f, 1.0f, 0.200000003f);
    const float4 c4 = float4(0.600000024f, 0.400000006f, 8.0f, 31.875f);
    const float4 c10 = float4(4.0f, -2.0f, 0.0f, 0.0f);
    const float4 c11 = float4(3.5f, 1.0f, 0.5f, 0.0f);
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

    r0.xy = (v1.zw) * (c11.yz);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c11.yz) + (c11.wz);
    r3 = tex2D(s13, r0.xy);
    r2.w = r3.y;
    r7.xy = (r2.yw) * (c10.xx) + (c10.yy);
    r2.w = dot(r7.xy, r7.xy) + (c2.x);
    r0 = tex2D(s1, v1.xy);
    r6.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = tex2D(s4, v6.zw);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c3.xxxx) * (v7) + (c3.yyyy);
    r5.x = dot(r1.xy, r0.xy) + (c2.x);
    r5.y = dot(r1.xy, r0.zw) + (c2.x);
    r1 = tex2D(s6, v6.zw);
    r5.z = r1.y;
    r4 = tex2D(s5, v1.xy);
    r6.z = r4.y;
    r0 = tex2D(s3, v6.zw);
    r5.w = (r0.w) * (v0.z) + (c2.y);
    r0.w = exp2(-(r2.w));
    r8.xyz = float3(((r5.w) >= 0.0f ? (r5.x) : (r6.x)), ((r5.w) >= 0.0f ? (r5.y) : (r6.y)), ((r5.w) >= 0.0f ? (r5.z) : (r6.z)));
    r2.w = (r0.w) * (c4.x) + (c4.y);
    r0.w = dot(r8.xy, r8.xy) + (c2.x);
    r1 = (r1.wwww) * (c2.xxxz) + (c2.wwwx);
    r0.w = exp2(-(r0.w));
    r3.w = r4.w;
    r0.w = (r0.w) * (c4.x) + (c4.y);
    r2.y = (r2.w) * (r0.w);
    r2.w = dot(r7.xy, r8.xy) + (c2.x);
    r4 = tex2D(s14, v1.zw);
    r6.xy = (r4.xy) * (c4.ww);
    r4.w = saturate((r2.w) * (r2.y) + (r2.y));
    r3.xy = (r3.xz) * (r6.yy);
    r2.w = (r4.y) * (c4.w) + (-(r3.x));
    r5.xz = (r3.xy) * (c10.xx);
    r2.w = (r3.z) * (-(r6.y)) + (r2.w);
    r2.xy = (r2.xz) * (r6.xx);
    r5.y = (r2.w) + (r2.w);
    r2.w = (r4.x) * (c4.w) + (-(r2.x));
    r3.xyz = (r4.www) * (r5.xyz);
    r2.w = (r2.z) * (-(r6.x)) + (r2.w);
    r5.xz = (r2.xy) * (c10.xx);
    r5.y = (r2.w) + (r2.w);
    r3.xyz = (r5.xyz) * (r0.www) + (r3.xyz);
    r2.xyz = v2.xyz;
    r2.xyz = (r8.xxx) * (v4.xyz) + (r2.xyz);
    r4.xyz = (r8.zzz) * (r3.xyz);
    r2.xyz = (r8.yyy) * (v3.xyz) + (r2.xyz);
    r9.xyz = normalize(r2.xyz);
    r7.xyz = normalize(v5.xyz);
    r2 = tex2D(s2, v6.xy);
    r2.xyz = (r2.xyz) + (c3.yyy);
    r0.w = dot(r7.xyz, r9.xyz);
    r6.xyz = (v0.yyy) * (r2.xyz) + (c3.zzz);
    r0.w = (r0.w) + (r0.w);
    r3.xyz = (r6.xyz) * (c3.www);
    r2.xyz = (r9.xyz) * (-(r0.www)) + (r7.xyz);
    r1 = float4(((r5.w) >= 0.0f ? (r1.x) : (r3.x)), ((r5.w) >= 0.0f ? (r1.y) : (r3.y)), ((r5.w) >= 0.0f ? (r1.z) : (r3.z)), ((r5.w) >= 0.0f ? (r1.w) : (r3.w)));
    r0.w = saturate(dot(r9.xyz, -(r7.xyz)));
    r2.w = (r1.w) * (c4.z);
    r2 = texCUBElod(s15, r2);
    r0.w = (-(r0.w)) + (c3.z);
    r2.w = (r0.w) * (r0.w);
    r1.w = (r1.w) * (c11.x) + (c11.y);
    r0.w = (r0.w) * (r2.w);
    r1.w = 1.0f / (r1.w);
    r0.w = (r0.w) * (r1.w);
    r3.xyz = (r1.xyz) * (-(r1.xyz)) + (c3.zzz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3.xyz = (r0.www) * (r3.xyz);
    r2.xyz = (r8.zzz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz) + (r3.xyz);
    r0.w = dot(c[5].xyz, r7.xyz);
    r3.xyz = (r2.xyz) * (r1.xyz);
    r1 = tex2D(s0, v1.xy);
    r2.xyz = (r6.xyz) * (r1.xyz);
    r1.xyz = (r5.xyz) * (r3.xyz);
    r0.xyz = float3(((r5.w) >= 0.0f ? (r0.x) : (r2.x)), ((r5.w) >= 0.0f ? (r0.y) : (r2.y)), ((r5.w) >= 0.0f ? (r0.z) : (r2.z)));
    r2.xyz = (r1.xyz) * (c4.zzz);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.w = saturate((c[7].y) * (r0.w) + (c[7].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[6].xyz);
    r1.xyz = (r1.xyz) * (r4.xyz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[8].w;

    return oC0;
}

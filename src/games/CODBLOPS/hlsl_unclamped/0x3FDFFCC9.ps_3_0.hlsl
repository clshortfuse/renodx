// Mechanically reconstructed from 0x3FDFFCC9.ps_3_0.cso.
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
sampler2D s7 : register(s7);
sampler2D s8 : register(s8);
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
    float4 v8 : TEXCOORD7;
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
    float4 v8 = input.v8;
    const float4 c1 = float4(3.5f, 1.0f, 4.0f, -2.0f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(2.0f, -1.0f, 0.0f, -0.5f);
    const float4 c4 = float4(0.600000024f, 0.400000006f, 8.0f, 31.875f);
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
    r2.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0 = tex2D(s4, v6.xy);
    r1.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0 = (c3.xxxx) * (v7) + (c3.yyyy);
    r0.x = dot(r1.xy, r0.xy) + (c3.z);
    r0.y = dot(r1.xy, r0.zw) + (c3.z);
    r1 = tex2D(s2, v6.xy);
    r7.w = (r1.w) * (v0.y);
    r3.xy = lerp(r2.xy, r0.xy, r7.ww);
    r2.zw = c[10].xy;
    r0 = tex2D(s5, v6.zw);
    r4.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0 = (c3.xxxx) * (v8) + (c3.yyyy);
    r2.x = dot(r4.xy, r0.xy) + (c3.z);
    r0.xy = c[8].xy;
    r3.zw = (-(r0.xy)) + (c[9].xy);
    r2.y = dot(r4.xy, r0.zw) + (c3.z);
    r3.zw = (r7.ww) * (r3.zw) + (c[8].xy);
    r0 = tex2D(s3, v6.zw);
    r1.w = (r0.w) * (v0.z) + (c3.w);
    r3 = float4(((r1.w) >= 0.0f ? (r2.x) : (r3.x)), ((r1.w) >= 0.0f ? (r2.y) : (r3.y)), ((r1.w) >= 0.0f ? (r2.z) : (r3.z)), ((r1.w) >= 0.0f ? (r2.w) : (r3.w)));
    r2.xy = (v1.zw) * (-(c3.yw));
    r2 = tex2D(s13, r2.xy);
    r4.xy = (v1.zw) * (-(c3.yw)) + (-(c3.zw));
    r5 = tex2D(s13, r4.xy);
    r2.w = r5.y;
    r0.w = dot(r3.xy, r3.xy) + (c3.z);
    r4.xy = (r2.yw) * (c1.zz) + (c1.ww);
    r2.w = exp2(-(r0.w));
    r0.w = dot(r4.xy, r4.xy) + (c3.z);
    r2.w = (r2.w) * (c4.x) + (c4.y);
    r2.y = exp2(-(r0.w));
    r0.w = dot(r4.xy, r3.xy) + (c3.z);
    r2.y = (r2.y) * (c4.x) + (c4.y);
    r4 = tex2D(s14, v1.zw);
    r7.xy = (r4.xy) * (c4.ww);
    r2.y = (r2.w) * (r2.y);
    r5.xy = (r5.xz) * (r7.yy);
    r0.w = saturate((r0.w) * (r2.y) + (r2.y));
    r2.y = (r4.y) * (c4.w) + (-(r5.x));
    r6.xz = (r5.xy) * (c1.zz);
    r2.y = (r5.z) * (-(r7.y)) + (r2.y);
    r6.y = (r2.y) + (r2.y);
    r2.xy = (r2.xz) * (r7.xx);
    r5.xyz = (r0.www) * (r6.xyz);
    r0.w = (r4.x) * (c4.w) + (-(r2.x));
    r8.xz = (r2.xy) * (c1.zz);
    r4.xyz = v2.xyz;
    r4.xyz = (r3.xxx) * (v4.xyz) + (r4.xyz);
    r0.w = (r2.z) * (-(r7.x)) + (r0.w);
    r2.xyz = (r3.yyy) * (v3.xyz) + (r4.xyz);
    r10.xyz = normalize(r2.xyz);
    r9.xyz = normalize(v5.xyz);
    r8.y = (r0.w) + (r0.w);
    r0.w = dot(r9.xyz, r10.xyz);
    r2.xyz = (r8.xyz) * (r2.www) + (r5.xyz);
    r0.w = (r0.w) + (r0.w);
    r7.xyz = (r3.www) * (r2.xyz);
    r4.xyz = (r10.xyz) * (-(r0.www)) + (r9.xyz);
    r6 = tex2D(s6, v1.xy);
    r2 = tex2D(s7, v6.xy);
    r5 = lerp(r6, r2, r7.wwww);
    r2 = tex2D(s8, v6.zw);
    r2 = float4(((r1.w) >= 0.0f ? (r2.x) : (r5.x)), ((r1.w) >= 0.0f ? (r2.y) : (r5.y)), ((r1.w) >= 0.0f ? (r2.z) : (r5.z)), ((r1.w) >= 0.0f ? (r2.w) : (r5.w)));
    r0.w = saturate(dot(r10.xyz, -(r9.xyz)));
    r4.w = (r2.w) * (c4.z);
    r4 = texCUBElod(s15, r4);
    r0.w = (-(r0.w)) + (-(c3.y));
    r3.w = (r0.w) * (r0.w);
    r2.w = (r2.w) * (c1.x) + (c1.y);
    r0.w = (r0.w) * (r3.w);
    r2.w = 1.0f / (r2.w);
    r0.w = (r0.w) * (r2.w);
    r6.xyz = (r2.xyz) * (-(r2.xyz)) + (-(c3.yyy));
    r5.xyz = (r4.xyz) * (r4.xyz);
    r4.xyz = (r0.www) * (r6.xyz);
    r3.xyz = (r3.zzz) * (r5.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz) + (r4.xyz);
    r0.w = dot(c[5].xyz, r9.xyz);
    r4.xyz = (r3.xyz) * (r2.xyz);
    r2 = tex2D(s0, v1.xy);
    r3.xyz = lerp(r2.xyz, r1.xyz, r7.www);
    r1.xyz = (r8.xyz) * (r4.xyz);
    r0.xyz = float3(((r1.w) >= 0.0f ? (r0.x) : (r3.x)), ((r1.w) >= 0.0f ? (r0.y) : (r3.y)), ((r1.w) >= 0.0f ? (r0.z) : (r3.z)));
    r2.xyz = (r1.xyz) * (c4.zzz);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.w = saturate((c[7].y) * (r0.w) + (c[7].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[6].xyz);
    r1.xyz = (r1.xyz) * (r7.xyz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[11].w;

    return oC0;
}

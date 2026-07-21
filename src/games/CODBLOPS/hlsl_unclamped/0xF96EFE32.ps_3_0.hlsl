// Mechanically reconstructed from 0xF96EFE32.ps_3_0.cso.
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
    const float4 c1 = float4(-1.0f, 1.0f, 0.0f, 8.0f);
    const float4 c2 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 0.0f, 0.0f);
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

    r0.xy = (v1.zw) * (c2.xy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c2.xy) + (c2.zy);
    r2 = tex2D(s13, r0.xy);
    r1.w = r2.y;
    r0 = tex2D(s1, v1.xy);
    r0.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r5 = tex2D(s3, v7.zw);
    r5.w = (r5.w) * (v0.z);
    r3.xy = (r1.yw) * (c3.xx) + (c3.yy);
    r4.xy = (r5.ww) * (-(r0.xy)) + (r0.xy);
    r0.w = dot(r3.xy, r3.xy) + (c1.z);
    r0.z = dot(r4.xy, r4.xy) + (c1.z);
    r0.w = exp2(-(r0.w));
    r0.z = exp2(-(r0.z));
    r0.w = (r0.w) * (c4.x) + (c4.y);
    r6.w = (r0.z) * (c4.x) + (c4.y);
    r1.w = (r0.w) * (r6.w);
    r0 = tex2D(s14, v1.zw);
    r8.xy = (r0.xy) * (c2.ww);
    r0.w = dot(r3.xy, r4.xy) + (c1.z);
    r2.xy = (r2.xz) * (r8.yy);
    r0.w = saturate((r0.w) * (r1.w) + (r1.w));
    r0.z = (r0.y) * (c2.w) + (-(r2.x));
    r3.xz = (r2.xy) * (c3.xx);
    r0.z = (r2.z) * (-(r8.y)) + (r0.z);
    r3.y = (r0.z) + (r0.z);
    r1.xy = (r1.xz) * (r8.xx);
    r7.xyz = (r0.www) * (r3.xyz);
    r1.w = (r0.x) * (c2.w) + (-(r1.x));
    r6.xz = (r1.xy) * (c3.xx);
    r0 = v2;
    r0.xyz = (r4.xxx) * (v5.xyz) + (r0.xyz);
    r6.y = (r1.z) * (-(r8.x)) + (r1.w);
    r0.xyz = (r4.yyy) * (v4.xyz) + (r0.xyz);
    r9.xyz = normalize(r0.xyz);
    r8.xyz = normalize(v6.xyz);
    r0.xy = c[20].xy;
    r0.xy = (-(r0.xy)) + (c[21].xy);
    r0.z = dot(r8.xyz, r9.xyz);
    r10.xy = (r5.ww) * (r0.xy) + (c[20].xy);
    r2.w = (r0.z) + (r0.z);
    r3 = tex2D(s5, v7.zw);
    r1 = tex2D(s2, v7.xy);
    r0.xyz = (r1.xyz) + (c1.xxx);
    r0.xyz = (v0.yyy) * (r0.xyz) + (c1.yyy);
    r4 = tex2D(s4, v1.xy);
    r4.xyz = (r0.xyz) * (r4.xyz);
    r2.xyz = (r9.xyz) * (-(r2.www)) + (r8.xyz);
    r1 = lerp(r4, r3, r5.wwww);
    r3.w = saturate(dot(r9.xyz, -(r8.xyz)));
    r2.w = (r1.w) * (c1.w);
    r2 = texCUBElod(s15, r2);
    r3.w = (-(r3.w)) + (c1.y);
    r3.z = (r3.w) * (r3.w);
    r2.w = (r1.w) * (c4.z) + (c4.w);
    r1.w = (r3.w) * (r3.z);
    r2.w = 1.0f / (r2.w);
    r1.w = (r1.w) * (r2.w);
    r3.xyz = (r1.xyz) * (-(r1.xyz)) + (c1.yyy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3.xyz = (r1.www) * (r3.xyz);
    r2.xyz = (r10.xxx) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz) + (r3.xyz);
    r6.y = (r6.y) + (r6.y);
    r1.xyz = (r2.xyz) * (r1.xyz);
    r2.xyz = (r6.xyz) * (r6.www) + (r7.xyz);
    r1.xyz = (r6.xyz) * (r1.xyz);
    r7.xyz = (r10.yyy) * (r2.xyz);
    r8.xyz = (r1.xyz) * (c1.www);
    r6 = tex2D(s0, v1.xy);
    r4 = (-(v6.yyyy)) + (c[6]);
    r1 = (r4) * (r4);
    r3 = (-(v6.xxxx)) + (c[5]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v6.zzzz)) + (c[7]);
    r5.xyz = (r6.xyz) * (-(r0.xyz)) + (r5.xyz);
    r1 = (r2) * (r2) + (r1);
    r10.xyz = (r5.www) * (r5.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r0.xyz = (r6.xyz) * (r0.xyz) + (r10.xyz);
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
    r0.xyz = max(((r0.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.y;

    return oC0;
}

// Mechanically reconstructed from 0xA76F8610.ps_3_0.cso.
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
    const float4 c2 = float4(0.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 3.5f, 1.0f);
    const float4 c4 = float4(2.0f, -1.0f, 1.0f, 0.0f);
    const float4 c10 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c11 = float4(4.0f, -2.0f, 0.0f, 0.0f);
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

    r0 = tex2D(s3, v6.xy);
    r2.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = tex2D(s4, v6.zw);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c4.xxxx) * (v7) + (c4.yyyy);
    r0.x = dot(r1.xy, r0.xy) + (c4.w);
    r0.y = dot(r1.xy, r0.zw) + (c4.w);
    r1 = tex2D(s1, v6.xy);
    r7.w = (r1.w) * (v0.y);
    r3.xy = (r7.ww) * (-(r2.xy)) + (r0.xy);
    r0 = tex2D(s2, v6.zw);
    r8.w = (r0.w) * (v0.z);
    r3.xy = (r3.xy) * (r8.ww);
    r9.xy = (r7.ww) * (r2.xy) + (r3.xy);
    r2.xyz = v2.xyz;
    r2.xyz = (r9.xxx) * (v4.xyz) + (r2.xyz);
    r2.xyz = (r9.yyy) * (v3.xyz) + (r2.xyz);
    r8.xyz = normalize(r2.xyz);
    r7.xyz = normalize(v5.xyz);
    r2.w = dot(r7.xyz, r8.xyz);
    r3.w = (r2.w) + (r2.w);
    r2 = tex2D(s5, v6.xy);
    r2 = (r2) + (c4.wwwy);
    r4.xyz = (r8.xyz) * (-(r3.www)) + (r7.xyz);
    r6 = (r7.wwww) * (r2) + (c4.wwwz);
    r3 = tex2D(s6, v6.zw);
    r5 = (r3.wwww) * (c2.xxxy) + (c2.zzzx);
    r3.w = saturate(dot(r8.xyz, -(r7.xyz)));
    r2 = lerp(r6, r5, r8.wwww);
    r5.w = dot(c[5].xyz, r7.xyz);
    r4.w = (r2.w) * (c2.w);
    r4 = texCUBElod(s15, r4);
    r3.z = c4.y;
    r5.xy = (r3.zz) + (c[8].xy);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r5.xy = (r7.ww) * (r5.xy) + (c4.zz);
    r7.xy = lerp(r5.xy, r3.yy, r8.ww);
    r3.z = (-(r3.w)) + (c4.z);
    r3.y = (r3.z) * (r3.z);
    r3.w = (r2.w) * (c3.z) + (c3.w);
    r2.w = (r3.z) * (r3.y);
    r3.w = 1.0f / (r3.w);
    r2.w = (r2.w) * (r3.w);
    r3.xyz = (r2.xyz) * (-(r2.xyz)) + (c4.zzz);
    r5.xyz = (r4.xyz) * (r7.xxx);
    r3.xyz = (r2.www) * (r3.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz) + (r3.xyz);
    r3.xy = (v1.zw) * (c10.xy);
    r4 = tex2D(s13, r3.xy);
    r3 = tex2D(s14, v1.zw);
    r8.xy = (r3.xy) * (c10.ww);
    r6.xyz = (r5.xyz) * (r2.xyz);
    r2.xy = (r4.xz) * (r8.xx);
    r2.w = (r3.x) * (c10.w) + (-(r2.x));
    r5.xz = (r2.xy) * (c11.xx);
    r3.w = (r4.z) * (-(r8.x)) + (r2.w);
    r2.xy = (v1.zw) * (c10.xy) + (c10.zy);
    r2 = tex2D(s13, r2.xy);
    r10.xy = (r8.yy) * (r2.xz);
    r2.x = r4.y;
    r2.w = (r3.y) * (c10.w) + (-(r10.x));
    r3.xz = (r10.xy) * (c11.xx);
    r3.y = (r2.z) * (-(r8.y)) + (r2.w);
    r2.xy = (r2.xy) * (c11.xx) + (c11.yy);
    r2.z = dot(r2.xy, r2.xy) + (c4.w);
    r2.w = dot(r9.xy, r9.xy) + (c4.w);
    r2.z = exp2(-(r2.z));
    r2.w = exp2(-(r2.w));
    r4.w = (r2.z) * (c3.x) + (c3.y);
    r2.w = (r2.w) * (c3.x) + (c3.y);
    r2.z = dot(r2.xy, r9.xy) + (c4.w);
    r2.y = (r4.w) * (r2.w);
    r3.y = (r3.y) + (r3.y);
    r2.z = saturate((r2.z) * (r2.y) + (r2.y));
    r5.y = (r3.w) + (r3.w);
    r2.xyz = (r3.xyz) * (r2.zzz);
    r3.xyz = (r6.xyz) * (r5.xyz);
    r2.xyz = (r5.xyz) * (r2.www) + (r2.xyz);
    r4.xyz = (r3.xyz) * (c2.www);
    r3.xyz = (r7.yyy) * (r2.xyz);
    r2 = tex2D(s0, v1.xy);
    r5.xyz = lerp(r2.xyz, r1.xyz, r7.www);
    r2.w = (r2.w) * (-(v0.x)) + (c4.z);
    r2.z = (r1.w) * (-(v0.y)) + (c4.z);
    r1.xyz = lerp(r5.xyz, r0.xyz, r8.www);
    r1.w = (r0.w) * (-(v0.z)) + (c4.z);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r2.w) * (-(r2.z)) + (c4.z);
    r2.w = saturate((c[7].y) * (r5.w) + (c[7].x));
    r1.xyz = c[0].xyz;
    r1.xyz = (-(r1.xyz)) + (c[6].xyz);
    r0.w = (-(r0.w)) + (c4.z);
    r1.xyz = (r2.www) * (r1.xyz) + (c[0].xyz);
    r0.w = (r0.w) * (-(r1.w)) + (c4.z);
    r1.xyz = (r1.xyz) * (c[0].www);
    r0.xyz = (r0.xyz) * (r3.xyz) + (r4.xyz);
    r1.xyz = (r0.www) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (-(r1.xyz));
    r0.xyz = (v2.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r0.w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}

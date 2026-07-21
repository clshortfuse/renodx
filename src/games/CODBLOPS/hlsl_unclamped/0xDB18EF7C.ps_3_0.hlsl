// Mechanically reconstructed from 0xDB18EF7C.ps_3_0.cso.
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
    const float4 c1 = float4(2.0f, -1.0f, -0.0f, -0.200000003f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 8.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 0.0f, 0.0f);
    const float4 c4 = float4(3.5f, 1.0f, 0.5f, -0.0f);
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

    r0 = tex2D(s1, v0.xy);
    r2.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s3, v6.zw);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = (c1.xxxx) * (v7) + (c1.yyyy);
    r0.x = dot(r1.xy, r0.xy) + (c1.z);
    r0.y = dot(r1.xy, r0.zw) + (c1.z);
    r1 = tex2D(s2, v6.zw);
    r1.w = (r1.w) * (v6.y);
    r7.xy = lerp(r2.xy, r0.xy, r1.ww);
    r0 = v1;
    r0.xyz = (r7.xxx) * (v4.xyz) + (r0.xyz);
    r2.xyz = (r7.yyy) * (v3.xyz) + (r0.xyz);
    r0.xyz = normalize(r2.xyz);
    r6.xyz = normalize(v5.xyz);
    r2.w = dot(r6.xyz, r0.xyz);
    r2.w = (r2.w) + (r2.w);
    r2.xyz = (r0.xyz) * (-(r2.www)) + (r6.xyz);
    r4 = tex2D(s5, v6.zw);
    r5.xyz = c1.www;
    r3 = tex2D(s4, v0.xy);
    r5.w = -(r3.w);
    r4 = (r4) + (r5);
    r5 = (r3.wwww) * (-(c1.zzzy)) + (-(c1.wwwz));
    r3.w = saturate(dot(r0.xyz, -(r6.xyz)));
    r4 = (r1.wwww) * (r4) + (r5);
    r6.xy = lerp(r3.yy, c[5].xy, r1.ww);
    r2.w = (r4.w) * (c2.z);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r6.xxx) * (r0.xyz);
    r2.w = (-(r3.w)) + (-(c1.y));
    r2.y = (r2.w) * (r2.w);
    r2.z = (r4.w) * (c4.x) + (c4.y);
    r2.w = (r2.w) * (r2.y);
    r2.z = 1.0f / (r2.z);
    r2.w = (r2.w) * (r2.z);
    r2.xyz = (r4.xyz) * (-(r4.xyz)) + (-(c1.yyy));
    r5.xyz = (r2.www) * (r2.xyz);
    r2.xy = (v0.zw) * (c4.yz);
    r2 = tex2D(s13, r2.xy);
    r3 = tex2D(s14, v0.zw);
    r8.xy = (r3.xy) * (c2.ww);
    r4.xyz = (r4.xyz) * (r4.xyz) + (r5.xyz);
    r9.xy = (r2.xz) * (r8.xx);
    r5.xyz = (r0.xyz) * (r4.xyz);
    r0.z = (r3.x) * (c2.w) + (-(r9.x));
    r4.xz = (r9.xy) * (c3.xx);
    r0.z = (r2.z) * (-(r8.x)) + (r0.z);
    r0.x = r2.y;
    r2.xy = (v0.zw) * (c4.yz) + (c4.wz);
    r2 = tex2D(s13, r2.xy);
    r9.xy = (r8.yy) * (r2.xz);
    r4.y = (r0.z) + (r0.z);
    r0.z = (r3.y) * (c2.w) + (-(r9.x));
    r3.xz = (r9.xy) * (c3.xx);
    r0.y = r2.y;
    r2.z = (r2.z) * (-(r8.y)) + (r0.z);
    r0.xy = (r0.xy) * (c3.xx) + (c3.yy);
    r2.w = dot(r0.xy, r0.xy) + (c1.z);
    r0.z = dot(r7.xy, r7.xy) + (c1.z);
    r2.w = exp2(-(r2.w));
    r0.z = exp2(-(r0.z));
    r2.y = (r2.w) * (c2.x) + (c2.y);
    r2.w = (r0.z) * (c2.x) + (c2.y);
    r0.z = dot(r0.xy, r7.xy) + (c1.z);
    r0.y = (r2.y) * (r2.w);
    r3.y = (r2.z) + (r2.z);
    r0.z = saturate((r0.z) * (r0.y) + (r0.y));
    r2.xyz = (r5.xyz) * (r4.xyz);
    r0.xyz = (r3.xyz) * (r0.zzz);
    r3.xyz = (r2.xyz) * (c2.zzz);
    r4.xyz = (r4.xyz) * (r2.www) + (r0.xyz);
    r2 = tex2D(s0, v0.xy);
    r0.xyz = lerp(r2.xyz, r1.xyz, r1.www);
    r1.xyz = (r6.yyy) * (r4.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = -(c1.y);

    return oC0;
}

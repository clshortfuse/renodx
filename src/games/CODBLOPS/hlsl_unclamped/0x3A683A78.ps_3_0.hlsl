// Mechanically reconstructed from 0x3A683A78.ps_3_0.cso.
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-1.0f, 0.0f, 0.200000003f, 1.0f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 8.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 0.0f, 0.0f);
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

    r0.xy = (v0.zw) * (c4.yz);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v0.zw) * (c4.yz) + (c4.wz);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r1 = tex2D(s2, v6.zw);
    r1.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r6 = tex2D(s1, v6.zw);
    r6.w = (r6.w) * (v6.y);
    r3.xy = (r0.yw) * (c3.xx) + (c3.yy);
    r5.xy = (r1.xy) * (r6.ww);
    r0.w = dot(r3.xy, r3.xy) + (c1.y);
    r0.y = dot(r5.xy, r5.xy) + (c1.y);
    r0.w = exp2(-(r0.w));
    r0.y = exp2(-(r0.y));
    r0.w = (r0.w) * (c2.x) + (c2.y);
    r3.w = (r0.y) * (c2.x) + (c2.y);
    r0.y = (r0.w) * (r3.w);
    r1 = tex2D(s14, v0.zw);
    r7.xy = (r1.xy) * (c2.ww);
    r0.w = dot(r3.xy, r5.xy) + (c1.y);
    r2.xy = (r2.xz) * (r7.yy);
    r0.w = saturate((r0.w) * (r0.y) + (r0.y));
    r0.y = (r1.y) * (c2.w) + (-(r2.x));
    r3.xz = (r2.xy) * (c3.xx);
    r0.y = (r2.z) * (-(r7.y)) + (r0.y);
    r3.y = (r0.y) + (r0.y);
    r0.xy = (r0.xz) * (r7.xx);
    r4.xyz = (r0.www) * (r3.xyz);
    r0.w = (r1.x) * (c2.w) + (-(r0.x));
    r3.xz = (r0.xy) * (c3.xx);
    r3.y = (r0.z) * (-(r7.x)) + (r0.w);
    r1 = tex2D(s3, v6.zw);
    r0 = v1;
    r0.xyz = (r5.xxx) * (v4.xyz) + (r0.xyz);
    r0.xyz = (r5.yyy) * (v3.xyz) + (r0.xyz);
    r10.xyz = normalize(r0.xyz);
    r0.xyz = normalize(v5.xyz);
    r2.yzw = (r1.wyy) + (c1.xyx);
    r1.w = dot(r0.xyz, r10.xyz);
    r2.xy = (r6.ww) * (r2.yw) + (c1.ww);
    r1.w = (r1.w) + (r1.w);
    r1.xyz = (r10.xyz) * (-(r1.www)) + (r0.xyz);
    r0.z = saturate(dot(r10.xyz, -(r0.xyz)));
    r1.w = (r2.x) * (c2.z);
    r0.y = (r2.x) * (c4.x) + (c4.y);
    r1 = texCUBElod(s15, r1);
    r2.x = c1.z;
    r0.z = (-(r0.z)) + (c1.w);
    r2.xz = (r6.ww) * (r2.xz);
    r0.x = (r0.z) * (r0.z);
    r0.y = 1.0f / (r0.y);
    r0.z = (r0.z) * (r0.x);
    r2.w = (r0.y) * (r0.z);
    r1.w = (r2.x) * (-(r2.x)) + (c1.w);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r2.w) * (r1.w);
    r0.xyz = (r2.zzz) * (r0.xyz);
    r1.w = (r2.x) * (r2.x) + (r1.w);
    r3.y = (r3.y) + (r3.y);
    r0.xyz = (r0.xyz) * (r1.www);
    r1.xyz = (r3.xyz) * (r3.www) + (r4.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r8.xyz = (r2.yyy) * (r1.xyz);
    r9.xyz = (r0.xyz) * (c2.zzz);
    r7 = tex2D(s0, v0.xy);
    r4 = (-(v5.yyyy)) + (c[6]);
    r1 = (r4) * (r4);
    r3 = (-(v5.xxxx)) + (c[5]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v5.zzzz)) + (c[7]);
    r1 = (r2) * (r2) + (r1);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r0.xyz = lerp(r7.xyz, r6.xyz, r6.www);
    r4 = (r4) * (r5);
    r4 = (r10.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r10.xxxx) + (r4);
    r4.x = c1.w;
    r1 = saturate((r1) * (c[8]) + (r4.xxxx));
    r2 = saturate((r2) * (r10.zzzz) + (r3));
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1 = (r1) * (r2);
    r3.xyz = (r0.xyz) * (r8.xyz) + (r9.xyz);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r2.z = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.w;

    return oC0;
}

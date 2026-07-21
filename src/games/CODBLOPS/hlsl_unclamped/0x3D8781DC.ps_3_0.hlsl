// Mechanically reconstructed from 0x3D8781DC.ps_3_0.cso.
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
    const float4 c0 = float4(-1.0f, 1.0f, 0.0f, 0.200000003f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
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
    float4 oC0 = 0.0f;

    r0 = tex2D(s3, v7.zw);
    r0.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r2 = tex2D(s2, v7.zw);
    r5.w = (r2.w) * (v0.z);
    r8.xy = (r0.xy) * (r5.ww);
    r0 = v2;
    r0.xyz = (r8.xxx) * (v5.xyz) + (r0.xyz);
    r1.xyz = (r8.yyy) * (v4.xyz) + (r0.xyz);
    r0.xyz = normalize(r1.xyz);
    r3.xyz = normalize(v6.xyz);
    r1.w = saturate(dot(r0.xyz, -(r3.xyz)));
    r2.w = (-(r1.w)) + (c0.y);
    r3.w = (r2.w) * (r2.w);
    r1 = tex2D(s4, v7.zw);
    r1.yzw = (r1.wyy) + (c0.xzx);
    r2.w = (r2.w) * (r3.w);
    r7.xy = (r5.ww) * (r1.yw) + (c0.yy);
    r1.w = (r7.x) * (c4.x) + (c4.y);
    r1.x = c0.w;
    r1.w = 1.0f / (r1.w);
    r5.xz = (r5.ww) * (r1.xz);
    r1.z = (r2.w) * (r1.w);
    r1.w = (r5.x) * (-(r5.x)) + (c0.y);
    r1.z = (r1.z) * (r1.w);
    r1.w = dot(r3.xyz, r0.xyz);
    r2.w = (r5.x) * (r5.x) + (r1.z);
    r1.w = (r1.w) + (r1.w);
    r1.xyz = (r0.xyz) * (-(r1.www)) + (r3.xyz);
    r1.w = (r7.x) * (c2.z);
    r4 = texCUBElod(s15, r1);
    r0.xy = (v1.zw) * (c4.yz);
    r1 = tex2D(s13, r0.xy);
    r3 = tex2D(s14, v1.zw);
    r6.xy = (r3.xy) * (c2.ww);
    r0.xyz = (r4.xyz) * (r4.xyz);
    r5.xy = (r1.xz) * (r6.xx);
    r0.xyz = (r5.zzz) * (r0.xyz);
    r1.w = (r3.x) * (c2.w) + (-(r5.x));
    r4.xyz = (r2.www) * (r0.xyz);
    r0.z = (r1.z) * (-(r6.x)) + (r1.w);
    r5.xz = (r5.xy) * (c3.xx);
    r5.y = (r0.z) + (r0.z);
    r0.x = r1.y;
    r1.xyz = (r4.xyz) * (r5.xyz);
    r4.xyz = (r1.xyz) * (c2.zzz);
    r1.xy = (v1.zw) * (c4.yz) + (c4.wz);
    r1 = tex2D(s13, r1.xy);
    r9.xy = (r6.yy) * (r1.xz);
    r0.z = (r3.y) * (c2.w) + (-(r9.x));
    r6.xz = (r9.xy) * (c3.xx);
    r0.z = (r1.z) * (-(r6.y)) + (r0.z);
    r0.y = r1.y;
    r6.y = (r0.z) + (r0.z);
    r0.xy = (r0.xy) * (c3.xx) + (c3.yy);
    r0.z = dot(r0.xy, r0.xy) + (c0.z);
    r1.w = dot(r8.xy, r8.xy) + (c0.z);
    r0.z = exp2(-(r0.z));
    r1.w = exp2(-(r1.w));
    r0.z = (r0.z) * (c2.x) + (c2.y);
    r2.w = (r1.w) * (c2.x) + (c2.y);
    r3.w = dot(r0.xy, r8.xy) + (c0.z);
    r3.z = (r0.z) * (r2.w);
    r1 = tex2D(s1, v7.xy);
    r0.xyz = (r1.xyz) + (c0.xxx);
    r3.w = saturate((r3.w) * (r3.z) + (r3.z));
    r0.xyz = (v0.yyy) * (r0.xyz) + (c0.yyy);
    r1 = tex2D(s0, v1.xy);
    r3.xyz = (r1.xyz) * (-(r0.xyz)) + (r2.xyz);
    r2.xyz = (r6.xyz) * (r3.www);
    r3.xyz = (r5.www) * (r3.xyz);
    r2.xyz = (r5.xyz) * (r2.www) + (r2.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r3.xyz);
    r1.xyz = (r7.yyy) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r4.xyz);
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

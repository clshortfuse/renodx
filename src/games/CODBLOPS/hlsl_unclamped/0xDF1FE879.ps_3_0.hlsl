// Mechanically reconstructed from 0xDF1FE879.ps_3_0.cso.
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
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c2.xy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c2.xy) + (c2.zy);
    r2 = tex2D(s13, r0.xy);
    r1.w = r2.y;
    r3.xy = (r1.yw) * (c3.xx) + (c3.yy);
    r0 = tex2D(s1, v1.xy);
    r4.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.w = dot(r3.xy, r3.xy) + (c1.z);
    r0.z = dot(r4.xy, r4.xy) + (c1.z);
    r0.w = exp2(-(r0.w));
    r0.z = exp2(-(r0.z));
    r0.w = (r0.w) * (c4.x) + (c4.y);
    r2.w = (r0.z) * (c4.x) + (c4.y);
    r1.w = (r0.w) * (r2.w);
    r0 = tex2D(s14, v1.zw);
    r6.xy = (r0.xy) * (c2.ww);
    r0.w = dot(r3.xy, r4.xy) + (c1.z);
    r2.xy = (r2.xz) * (r6.yy);
    r0.w = saturate((r0.w) * (r1.w) + (r1.w));
    r0.z = (r0.y) * (c2.w) + (-(r2.x));
    r3.xz = (r2.xy) * (c3.xx);
    r0.z = (r2.z) * (-(r6.y)) + (r0.z);
    r3.y = (r0.z) + (r0.z);
    r1.xy = (r1.xz) * (r6.xx);
    r3.xyz = (r0.www) * (r3.xyz);
    r1.w = (r0.x) * (c2.w) + (-(r1.x));
    r5.xz = (r1.xy) * (c3.xx);
    r0 = v2;
    r0.xyz = (r4.xxx) * (v5.xyz) + (r0.xyz);
    r1.w = (r1.z) * (-(r6.x)) + (r1.w);
    r1.xyz = (r4.yyy) * (v4.xyz) + (r0.xyz);
    r0.xyz = normalize(r1.xyz);
    r2.xyz = normalize(v6.xyz);
    r5.y = (r1.w) + (r1.w);
    r1.w = dot(r2.xyz, r0.xyz);
    r6.xyz = (r5.xyz) * (r2.www) + (r3.xyz);
    r1.w = (r1.w) + (r1.w);
    r1.xyz = (r0.xyz) * (-(r1.www)) + (r2.xyz);
    r0.z = saturate(dot(r0.xyz, -(r2.xyz)));
    r2 = tex2D(s4, v1.xy);
    r1.w = (r2.w) * (c1.w);
    r1 = texCUBElod(s15, r1);
    r0.z = (-(r0.z)) + (c1.y);
    r0.y = (r0.z) * (r0.z);
    r1.w = (r0.z) * (r0.y);
    r3 = tex2D(s2, v7.xy);
    r0.xyz = (r3.xyz) + (c1.xxx);
    r2.w = (r2.w) * (c4.z) + (c4.w);
    r0.xyz = (v0.yyy) * (r0.xyz) + (c1.yyy);
    r3 = tex2D(s3, v7.zw);
    r3.xyz = (r3.xyz) + (c1.xxx);
    r2.xyz = (r2.xyz) * (r0.xyz);
    r3.xyz = (v0.zzz) * (r3.xyz) + (c1.yyy);
    r2.w = 1.0f / (r2.w);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r1.w = (r1.w) * (r2.w);
    r4.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.yyy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r4.xyz = (r1.www) * (r4.xyz);
    r1.xyz = (r1.xyz) * (c[5].xxx);
    r4.xyz = (r2.xyz) * (r2.xyz) + (r4.xyz);
    r2.xyz = (r6.xyz) * (c[5].yyy);
    r4.xyz = (r1.xyz) * (r4.xyz);
    r1 = tex2D(s0, v1.xy);
    r0.xyz = (r0.xyz) * (r1.xyz);
    r1.xyz = (r5.xyz) * (r4.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r1.xyz = (r1.xyz) * (c1.www);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[6].w;

    return oC0;
}

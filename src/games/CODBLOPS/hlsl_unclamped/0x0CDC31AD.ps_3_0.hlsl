// Mechanically reconstructed from 0x0CDC31AD.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(8.0f, 31.875f, 1.0f, 0.797884583f);
    const float4 c1 = float4(0.959999979f, 0.0399999991f, -2.0f, 3.0f);
    const float4 c2 = float4(0.0009765625f, 0.125f, 0.25f, 0.0f);
    const float4 c3 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0.xyz = (-(v4.xyz)) + (c[21].xyz);
    r6.y = dot(r0.xyz, r0.xyz);
    r1.w = rsqrt(r6.y);
    r1.xyz = normalize(v4.xyz);
    r3.xyz = (r0.xyz) * (r1.www) + (-(r1.xyz));
    r2.xyz = (r0.xyz) * (r1.www);
    r0.xyz = normalize(r3.xyz);
    r0.w = saturate(dot(r0.xyz, r2.xyz));
    r0.w = (-(r0.w)) + (c0.z);
    r6.x = 1.0f / (r1.w);
    r1.w = (r0.w) * (r0.w);
    r1.w = (r1.w) * (r1.w);
    r10.xyz = normalize(v2.xyz);
    r1.w = (r0.w) * (r1.w);
    r3.w = saturate(dot(r10.xyz, r2.xyz));
    r2 = tex2D(s1, v1.xy);
    r3.z = (r2.w) * (c0.w);
    r2.x = (r2.w) * (-(c0.w)) + (c0.z);
    r2.z = saturate(dot(r10.xyz, -(r1.xyz)));
    r0.w = (r3.w) * (r2.x) + (r3.z);
    r2.x = (r2.z) * (r2.x) + (r3.z);
    r1.w = (r1.w) * (c1.x) + (c1.y);
    r0.w = (r0.w) * (r2.x) + (c2.x);
    r2.x = 1.0f / (r0.w);
    r4.xy = (r2.ww) * (c3.xy) + (c3.zw);
    r3.y = saturate(dot(r10.xyz, r0.xyz));
    r3.z = exp2(r4.y);
    r0.y = pow(abs(r3.y), r3.z);
    r0.w = (r3.z) * (c2.y) + (c2.z);
    r0.z = (r3.w) * (r2.x);
    r0.w = (r0.y) * (r0.w);
    r2.x = (-(r2.z)) + (c0.z);
    r0.w = (r0.z) * (r0.w);
    r3.xyz = (r3.www) * (c[22].xyz);
    r0.w = (r1.w) * (r0.w);
    r2.z = 1.0f / (r4.x);
    r0.w = (r2.y) * (r0.w);
    r4.xyz = (r0.www) * (c[23].xyz);
    r5.xy = saturate((r6.xx) * (c[25].xy) + (c[25].zw));
    r1.w = dot(c[24].yz, r6.xy) + (c[24].x);
    r0.xy = (r5.xy) * (r5.xy);
    r5.xy = (r5.xy) * (c1.zz) + (c1.ww);
    r3.w = max(abs(r10.y), abs(r10.z));
    r5.xy = (r0.xy) * (r5.xy);
    r0.w = max(abs(r10.x), r3.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r10.xyz) * (c[5].xyz);
    r1.w = (r1.w) * (r5.x);
    r0.xyz = (r0.xyz) * (r0.www) + (v5.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.w = (r5.y) * (r1.w);
    r0.xyz = (r2.yyy) * (r0.xyz);
    r0.w = (r0.w) * (r1.w);
    r0.xyz = (r0.xyz) * (c0.yyy);
    r4.xyz = (r4.xyz) * (r0.www);
    r3.xyz = (r0.www) * (r3.xyz) + (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r1.w = dot(r1.xyz, r10.xyz);
    r1.w = (r1.w) + (r1.w);
    r1.xyz = (r10.xyz) * (-(r1.www)) + (r1.xyz);
    r1.w = (r2.w) * (c0.x);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0 = (r0.wxyz) * (v0.wxyz);
    r5.xyz = (r1.xyz) * (c0.xxx);
    r1 = tex3D(s11, v5.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r7.xyz = (r0.yzw) * (r0.yzw);
    r1.xyz = (r5.xyz) * (r1.xyz);
    r8.xyz = (r7.xyz) * (r3.xyz) + (r4.xyz);
    r9.xyz = (r1.xyz) * (c0.yyy);
    r0.w = (r2.x) * (r2.x);
    r5 = (-(v4.yyyy)) + (c[7]);
    r1 = (r5) * (r5);
    r4 = (-(v4.xxxx)) + (c[6]);
    r1 = (r4) * (r4) + (r1);
    r3 = (-(v4.zzzz)) + (c[8]);
    r0.w = (r2.x) * (r0.w);
    r1 = (r3) * (r3) + (r1);
    r0.w = (r2.z) * (r0.w);
    r6.x = rsqrt(r1.x);
    r6.y = rsqrt(r1.y);
    r6.z = rsqrt(r1.z);
    r6.w = rsqrt(r1.w);
    r0.w = (r0.w) * (c1.x) + (c1.y);
    r5 = (r5) * (r6);
    r5 = (r10.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r10.xxxx) + (r5);
    r0.y = c0.z;
    r1 = saturate((r1) * (c[9]) + (r0.yyyy));
    r3 = saturate((r3) * (r10.zzzz) + (r4));
    r4.xyz = (r9.xyz) * (r0.www);
    r1 = (r1) * (r3);
    r3.xyz = (r4.xyz) * (r2.yyy) + (r8.xyz);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r2.z = dot(c[20], r1);
    r1.xyz = (r7.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[26].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r0.x);
    r0.x = rsqrt(r1.x);
    r0.y = rsqrt(r1.y);
    r0.z = rsqrt(r1.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}

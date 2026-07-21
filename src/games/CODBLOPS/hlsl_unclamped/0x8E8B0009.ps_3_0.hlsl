// Mechanically reconstructed from 0x8E8B0009.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
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
    const float4 c1 = float4(1.0f, 3.5f, 0.5f, -0.0f);
    const float4 c2 = float4(-0.0f, 0.600000024f, 0.400000006f, 8.0f);
    const float4 c3 = float4(31.875f, 4.0f, -2.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c1.xz);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c1.xz) + (c1.wz);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r4.xy = (r0.yw) * (c3.yy) + (c3.zz);
    r1 = tex2D(s1, v1.xy);
    r3.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r0.w = dot(r4.xy, r4.xy) + (c2.x);
    r0.y = dot(r3.xy, r3.xy) + (c2.x);
    r0.w = exp2(-(r0.w));
    r0.y = exp2(-(r0.y));
    r0.w = (r0.w) * (c2.y) + (c2.z);
    r2.w = (r0.y) * (c2.y) + (c2.z);
    r1 = tex2D(s14, v1.zw);
    r7.xy = (r1.xy) * (c3.xx);
    r1.w = (r0.w) * (r2.w);
    r2.xy = (r2.xz) * (r7.yy);
    r0.w = dot(r4.xy, r3.xy) + (c2.x);
    r0.y = (r1.y) * (c3.x) + (-(r2.x));
    r0.w = saturate((r0.w) * (r1.w) + (r1.w));
    r0.y = (r2.z) * (-(r7.y)) + (r0.y);
    r2.xz = (r2.xy) * (c3.yy);
    r2.y = (r0.y) + (r0.y);
    r4.xyz = (r0.www) * (r2.xyz);
    r2.xyz = v2.xyz;
    r2.xyz = (r3.xxx) * (v5.xyz) + (r2.xyz);
    r0.xy = (r0.xz) * (r7.xx);
    r2.xyz = (r3.yyy) * (v4.xyz) + (r2.xyz);
    r5.xyz = normalize(r2.xyz);
    r6.xyz = normalize(v6.xyz);
    r0.w = (r1.x) * (c3.x) + (-(r0.x));
    r1.w = saturate(dot(r5.xyz, -(r6.xyz)));
    r3.xz = (r0.xy) * (c3.yy);
    r1.w = (-(r1.w)) + (c1.x);
    r1.y = (r0.z) * (-(r7.x)) + (r0.w);
    r1.x = (r1.w) * (r1.w);
    r0 = tex2D(s2, v1.xy);
    r1.z = (r0.w) * (c1.y) + (c1.x);
    r1.w = (r1.w) * (r1.x);
    r1.z = 1.0f / (r1.z);
    r3.y = (r1.y) + (r1.y);
    r2.z = (r1.w) * (r1.z);
    r1.xyz = (r0.xyz) * (-(r0.xyz)) + (c1.xxx);
    r1.w = dot(r6.xyz, r5.xyz);
    r2.xyz = (r2.zzz) * (r1.xyz);
    r1.z = (r1.w) + (r1.w);
    r1.w = (r0.w) * (c2.w);
    r1.xyz = (r5.xyz) * (-(r1.zzz)) + (r6.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r0.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r1.xyz) * (c[5].xxx);
    r1.xyz = (r3.xyz) * (r2.www) + (r4.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r2.xyz = (r1.xyz) * (c[5].yyy);
    r1.xyz = (r3.xyz) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r3.xyz = (r1.xyz) * (c2.www);
    r1.xyz = (r0.yzw) * (r0.yzw);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r0.w = (r0.x) * (c[6].w);
    r0.xyz = max(((r1.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.w = rsqrt(r0.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}

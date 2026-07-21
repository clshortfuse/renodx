// Mechanically reconstructed from 0x2D5B8FF9.ps_3_0.cso.
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
    const float4 c1 = float4(1.0f, 3.5f, 0.5f, 0.0f);
    const float4 c2 = float4(0.0f, 0.600000024f, 0.400000006f, 8.0f);
    const float4 c3 = float4(31.875f, 4.0f, -2.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c1.xz);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c1.xz) + (c1.wz);
    r0 = tex2D(s13, r0.xy);
    r1.w = r0.y;
    r4.xy = (r1.yw) * (c3.yy) + (c3.zz);
    r2 = tex2D(s1, v1.xy);
    r3.xy = (r2.wy) * (c0.xy) + (c0.zw);
    r0.w = dot(r4.xy, r4.xy) + (c2.x);
    r0.y = dot(r3.xy, r3.xy) + (c2.x);
    r0.w = exp2(-(r0.w));
    r0.y = exp2(-(r0.y));
    r0.w = (r0.w) * (c2.y) + (c2.z);
    r3.w = (r0.y) * (c2.y) + (c2.z);
    r2 = tex2D(s14, v1.zw);
    r5.xy = (r2.xy) * (c3.xx);
    r1.y = (r0.w) * (r3.w);
    r0.xy = (r0.xz) * (r5.yy);
    r0.w = dot(r4.xy, r3.xy) + (c2.x);
    r1.w = (r2.y) * (c3.x) + (-(r0.x));
    r0.w = saturate((r0.w) * (r1.y) + (r1.y));
    r1.w = (r0.z) * (-(r5.y)) + (r1.w);
    r0.xz = (r0.xy) * (c3.yy);
    r0.y = (r1.w) + (r1.w);
    r4.xyz = (r0.www) * (r0.xyz);
    r0 = v2;
    r0.xyz = (r3.xxx) * (v5.xyz) + (r0.xyz);
    r1.xy = (r1.xz) * (r5.xx);
    r3.xyz = (r3.yyy) * (v4.xyz) + (r0.xyz);
    r0.xyz = normalize(r3.xyz);
    r6.xyz = normalize(v6.xyz);
    r1.w = (r2.x) * (c3.x) + (-(r1.x));
    r2.w = saturate(dot(r0.xyz, -(r6.xyz)));
    r3.xz = (r1.xy) * (c3.yy);
    r2.w = (-(r2.w)) + (c1.x);
    r2.y = (r1.z) * (-(r5.x)) + (r1.w);
    r2.x = (r2.w) * (r2.w);
    r1 = tex2D(s2, v1.xy);
    r2.z = (r1.w) * (c1.y) + (c1.x);
    r2.w = (r2.w) * (r2.x);
    r2.z = 1.0f / (r2.z);
    r3.y = (r2.y) + (r2.y);
    r4.w = (r2.w) * (r2.z);
    r2.xyz = (r1.xyz) * (-(r1.xyz)) + (c1.xxx);
    r2.w = dot(r6.xyz, r0.xyz);
    r5.xyz = (r4.www) * (r2.xyz);
    r2.z = (r2.w) + (r2.w);
    r2.w = (r1.w) * (c2.w);
    r2.xyz = (r0.xyz) * (-(r2.zzz)) + (r6.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r1.xyz) * (r1.xyz) + (r5.xyz);
    r0.xyz = (r0.xyz) * (c[5].xxx);
    r1.xyz = (r3.xyz) * (r3.www) + (r4.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r2.xyz = (r1.xyz) * (c[5].yyy);
    r3.xyz = (r3.xyz) * (r0.xyz);
    r1 = tex2D(s0, v1.xy);
    r0.xyz = (r1.xyz) * (v0.xyz);
    r1.xyz = (r3.xyz) * (c2.www);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.x;

    return oC0;
}

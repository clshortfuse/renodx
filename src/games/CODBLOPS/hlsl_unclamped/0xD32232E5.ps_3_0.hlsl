// Mechanically reconstructed from 0xD32232E5.ps_3_0.cso.
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

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 0.5f);
    const float4 c1 = float4(31.875f, 4.0f, -2.0f, 0.0f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s0, v1.xy);
    r1.w = (r0.w) * (v0.x) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r1 = float4(((r1.w) >= 0.0f ? (r0.x) : (c0.z)), ((r1.w) >= 0.0f ? (r0.y) : (c0.z)), ((r1.w) >= 0.0f ? (r0.z) : (c0.z)), ((r1.w) >= 0.0f ? (r0.w) : (c0.z)));
    r0 = tex2D(s1, v4.xy);
    r2.w = (r0.w) * (v0.y) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r1 = float4(((r2.w) >= 0.0f ? (r0.x) : (r1.x)), ((r2.w) >= 0.0f ? (r0.y) : (r1.y)), ((r2.w) >= 0.0f ? (r0.z) : (r1.z)), ((r2.w) >= 0.0f ? (r0.w) : (r1.w)));
    r0 = tex2D(s2, v4.zw);
    r2.xy = (v1.zw) * (c0.yw);
    r4 = tex2D(s13, r2.xy);
    r2.xy = (v1.zw) * (c0.yw) + (c0.zw);
    r2 = tex2D(s13, r2.xy);
    r4.w = r2.y;
    r5.w = (r0.w) * (v0.z) + (c0.x);
    r3.xy = (r4.yw) * (c1.yy) + (c1.zz);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r2.w = dot(r3.xy, r3.xy) + (c0.z);
    r3 = tex2D(s14, v1.zw);
    r5.xy = (r3.xy) * (c1.xx);
    r2.w = exp2(-(r2.w));
    r4.xy = (r4.xz) * (r5.xx);
    r2.w = saturate((r2.w) * (c2.x) + (c2.y));
    r3.w = (r3.x) * (c1.x) + (-(r4.x));
    r3.xz = (r4.xy) * (c1.yy);
    r2.xy = (r2.xz) * (r5.yy);
    r4.w = (r4.z) * (-(r5.x)) + (r3.w);
    r3.w = (r3.y) * (c1.x) + (-(r2.x));
    r3.y = (r4.w) + (r4.w);
    r3.w = (r2.z) * (-(r5.y)) + (r3.w);
    r2.xz = (r2.xy) * (c1.yy);
    r2.y = (r3.w) + (r3.w);
    r0 = float4(((r5.w) >= 0.0f ? (r0.x) : (r1.x)), ((r5.w) >= 0.0f ? (r0.y) : (r1.y)), ((r5.w) >= 0.0f ? (r0.z) : (r1.z)), ((r5.w) >= 0.0f ? (r0.w) : (r1.w)));
    r1.xyz = (r2.xyz) * (r2.www) + (r3.xyz);
    r1.xyz = (r0.www) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (-(v3.xyz));
    r1.xyz = v3.xyz;
    r0.xyz = (v2.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (c[5].w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}

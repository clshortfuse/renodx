// Mechanically reconstructed from 0xD23E1F57.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(8.0f, 1.0f, 3.5f, 0.5f);
    const float4 c1 = float4(0.959999979f, 0.0399999991f, 31.875f, 4.0f);
    const float4 c2 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c0.yw);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r1.xy = (r0.yw) * (c2.xx) + (c2.yy);
    r0.w = dot(r1.xy, r1.xy) + (c3.z);
    r1 = tex2D(s14, v1.zw);
    r3.xy = (r1.xy) * (c1.zz);
    r0.w = exp2(-(r0.w));
    r2.xy = (r2.xz) * (r3.yy);
    r2.w = saturate((r0.w) * (c2.z) + (c2.w));
    r0.w = (r1.y) * (c1.z) + (-(r2.x));
    r4.xz = (r2.xy) * (c1.ww);
    r0.xy = (r0.xz) * (r3.xx);
    r1.w = (r2.z) * (-(r3.y)) + (r0.w);
    r0.w = (r1.x) * (c1.z) + (-(r0.x));
    r4.y = (r1.w) + (r1.w);
    r0.w = (r0.z) * (-(r3.x)) + (r0.w);
    r3.xz = (r0.xy) * (c1.ww);
    r3.y = (r0.w) + (r0.w);
    r0 = tex2D(s1, v1.xy);
    r5.xyz = normalize(v4.xyz);
    r2.xyz = normalize(v2.xyz);
    r0.z = dot(r5.xyz, r2.xyz);
    r0.z = (r0.z) + (r0.z);
    r1.xyz = (r2.xyz) * (-(r0.zzz)) + (r5.xyz);
    r0.z = saturate(dot(r2.xyz, -(r5.xyz)));
    r1.w = (r0.w) * (c0.x);
    r1 = texCUBElod(s15, r1);
    r0.x = (-(r0.z)) + (c0.y);
    r0.z = (r0.w) * (c0.z) + (c0.y);
    r0.w = (r0.x) * (r0.x);
    r0.w = (r0.x) * (r0.w);
    r0.z = 1.0f / (r0.z);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r0.w) * (r0.z);
    r1.xyz = (r0.yyy) * (r1.xyz);
    r0.w = (r0.w) * (c1.x) + (c1.y);
    r2.xyz = (r4.xyz) * (r2.www) + (r3.xyz);
    r1.xyz = (r1.xyz) * (r0.www);
    r2.xyz = (r0.yyy) * (r2.xyz);
    r1.xyz = (r3.xyz) * (r1.xyz);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r3.xyz = (r1.xyz) * (c0.xxx);
    r1.xyz = (r0.yzw) * (r0.yzw);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[5].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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

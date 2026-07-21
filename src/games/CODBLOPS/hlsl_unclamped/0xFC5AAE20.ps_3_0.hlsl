// Mechanically reconstructed from 0xFC5AAE20.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler3D s11 : register(s11);
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
    const float4 c1 = float4(8.0f, 31.875f, 1.0f, 3.5f);
    const float4 c2 = float4(0.959999979f, 0.0399999991f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex3D(s11, v7.xyz);
    r1 = tex2D(s1, v1.xy);
    r2.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1.xyz = v2.xyz;
    r1.xyz = (r2.xxx) * (v5.xyz) + (r1.xyz);
    r1.xyz = (r2.yyy) * (v4.xyz) + (r1.xyz);
    r3.xyz = normalize(r1.xyz);
    r4.xyz = normalize(v6.xyz);
    r0.w = dot(r4.xyz, r3.xyz);
    r0.w = (r0.w) + (r0.w);
    r2.xyz = (r3.xyz) * (-(r0.www)) + (r4.xyz);
    r1 = tex2D(s2, v1.xy);
    r2.w = (r1.w) * (c1.x);
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r2.xyz) * (c1.xxx);
    r0.w = saturate(dot(r3.xyz, -(r4.xyz)));
    r0.xyz = (r0.xyz) * (r2.xyz);
    r2.xyz = (r0.xyz) * (c1.yyy);
    r0.w = (-(r0.w)) + (c1.z);
    r0.y = (r0.w) * (r0.w);
    r0.z = (r1.w) * (c1.w) + (c1.z);
    r0.w = (r0.w) * (r0.y);
    r0.z = 1.0f / (r0.z);
    r0.w = (r0.w) * (r0.z);
    r1.z = max(abs(r3.y), abs(r3.z));
    r1.w = (r0.w) * (c2.x) + (c2.y);
    r0.w = max(abs(r3.x), r1.z);
    r0.xyz = (r3.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r0.w);
    r2.xyz = (r2.xyz) * (r1.www);
    r0.xyz = (r0.xyz) * (r0.www) + (v7.xyz);
    r0 = tex3D(s11, r0.xyz);
    r3.xyz = (r0.xyz) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r3.xyz = (r1.yyy) * (r3.xyz);
    r4.xyz = (r0.yzw) * (r0.yzw);
    r2.xyz = (r1.yyy) * (r2.xyz);
    r1.xyz = (r3.xyz) * (r4.xyz);
    r1.xyz = (r1.xyz) * (c1.yyy) + (r2.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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

// Mechanically reconstructed from 0x61843DEF.ps_3_0.cso.
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
    const float4 c1 = float4(0.200000003f, 8.0f, 31.875f, 1.0f);
    const float4 c2 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.0f);
    const float4 c3 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c4 = float4(0.125f, 0.25f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s1, v1.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r1.w = dot(v6.xyz, v6.xyz);
    r0 = v2;
    r0.xyz = (r1.xxx) * (v5.xyz) + (r0.xyz);
    r2.x = rsqrt(r1.w);
    r1.xyz = (r1.yyy) * (v4.xyz) + (r0.xyz);
    r8.xyz = (r2.xxx) * (v6.xyz);
    r0.xyz = normalize(r1.xyz);
    r2.z = saturate(dot(r0.xyz, -(r8.xyz)));
    r1 = tex2D(s2, v1.xy);
    r3.z = (r1.w) * (c2.x);
    r2.w = (r1.w) * (-(c2.x)) + (c2.y);
    r1.z = saturate(dot(r0.xyz, c[17].xyz));
    r2.y = (r2.z) * (r2.w) + (r3.z);
    r2.w = (r1.z) * (r2.w) + (r3.z);
    r3.xyz = (v6.xyz) * (-(r2.xxx)) + (c[17].xyz);
    r2.w = (r2.w) * (r2.y) + (c2.z);
    r3.w = (-(r2.z)) + (c1.w);
    r2.w = 1.0f / (r2.w);
    r4.w = (r1.z) * (r2.w);
    r2.xyz = normalize(r3.xyz);
    r5.xyz = (r1.zzz) * (c[18].xyz);
    r3.y = saturate(dot(r0.xyz, r2.xyz));
    r2.w = saturate(dot(r2.xyz, c[17].xyz));
    r2.xy = (r1.ww) * (c3.xy) + (c3.zw);
    r3.z = exp2(r2.y);
    r1.z = 1.0f / (r2.x);
    r2.x = pow(abs(r3.y), r3.z);
    r2.w = (-(r2.w)) + (c1.w);
    r2.y = (r3.z) * (c4.x) + (c4.y);
    r2.z = (r2.w) * (r2.w);
    r2.y = (r2.x) * (r2.y);
    r2.z = (r2.z) * (r2.z);
    r4.w = (r4.w) * (r2.y);
    r5.w = (r2.w) * (r2.z);
    r2 = tex2D(s0, v1.xy);
    r3.xyz = lerp(r2.xyz, c1.xxx, r1.xxx);
    r4.xyz = (r1.xxx) * (r2.xyz);
    r7.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (-(r3.xyz)) + (c1.www);
    r2.xyz = (r3.xyz) * (r5.www) + (r7.xyz);
    r2.w = max(abs(r0.y), abs(r0.z));
    r6.xyz = (r4.www) * (r2.xyz);
    r1.x = max(abs(r0.x), r2.w);
    r1.x = 1.0f / (r1.x);
    r2.xyz = (r0.xyz) * (c[5].xyz);
    r6.xyz = (r1.yyy) * (r6.xyz);
    r2.xyz = (r2.xyz) * (r1.xxx) + (v7.xyz);
    r2 = tex3D(s11, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r6.xyz = (r6.xyz) * (c[19].xyz);
    r2.xyz = (r1.yyy) * (r2.xyz);
    r6.xyz = (r2.www) * (r6.xyz);
    r2.xyz = (r2.xyz) * (c1.zzz);
    r5.xyz = (r2.www) * (r5.xyz) + (r2.xyz);
    r1.x = dot(r8.xyz, r0.xyz);
    r4.xyz = (r4.xyz) * (v0.xyz);
    r1.x = (r1.x) + (r1.x);
    r2.xyz = (r0.xyz) * (-(r1.xxx)) + (r8.xyz);
    r2.w = (r1.w) * (c1.y);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r8.xyz = (r0.xyz) * (c1.yyy);
    r2 = tex3D(s11, v7.xyz);
    r1.w = (r3.w) * (r3.w);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r3.w) * (r1.w);
    r0.xyz = (r8.xyz) * (r0.xyz);
    r1.w = (r1.z) * (r1.w);
    r0.xyz = (r0.xyz) * (c1.zzz);
    r3.xyz = (r3.xyz) * (r1.www) + (r7.xyz);
    r2.xyz = (r4.xyz) * (r5.xyz) + (r6.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.yyy) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.w;

    return oC0;
}

// Mechanically reconstructed from 0x533F2439.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 8.0f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(31.875f, 3.5f, 1.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r2 = tex3D(s11, v7.xyz);
    r0 = tex2D(s1, v1.xy);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r1.zw = c[6].xy;
    r0 = tex2D(s0, v1.xy);
    r6.w = (r0.w) * (v0.w) + (c0.x);
    r3 = float4(((r6.w) >= 0.0f ? (r1.x) : (c0.z)), ((r6.w) >= 0.0f ? (r1.y) : (c0.z)), ((r6.w) >= 0.0f ? (r1.z) : (c0.z)), ((r6.w) >= 0.0f ? (r1.w) : (c0.z)));
    r1 = v2;
    r1.xyz = (r3.xxx) * (v5.xyz) + (r1.xyz);
    r1.xyz = (r3.yyy) * (v4.xyz) + (r1.xyz);
    r5.xyz = normalize(r1.xyz);
    r6.xyz = normalize(v6.xyz);
    r1.z = dot(r6.xyz, r5.xyz);
    r2.w = (r1.z) + (r1.z);
    r1.xyz = (r2.xyz) * (r2.xyz);
    r4.xyz = (r5.xyz) * (-(r2.www)) + (r6.xyz);
    r2 = tex2D(s2, v1.xy);
    r2 = float4(((r6.w) >= 0.0f ? (r2.x) : (c0.z)), ((r6.w) >= 0.0f ? (r2.y) : (c0.z)), ((r6.w) >= 0.0f ? (r2.z) : (c0.z)), ((r6.w) >= 0.0f ? (r2.w) : (c0.y)));
    r3.y = saturate(dot(r5.xyz, -(r6.xyz)));
    r4.w = (r2.w) * (c0.w);
    r4 = texCUBElod(s15, r4);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r6.xyz = (r4.xyz) * (c0.www);
    r3.x = (-(r3.y)) + (c0.y);
    r4.w = (r3.x) * (r3.x);
    r3.y = (r2.w) * (c2.y) + (c2.z);
    r2.w = (r3.x) * (r4.w);
    r3.y = 1.0f / (r3.y);
    r2.w = (r2.w) * (r3.y);
    r4.xyz = (r2.xyz) * (-(r2.xyz)) + (c0.yyy);
    r1.xyz = (r1.xyz) * (r6.xyz);
    r4.xyz = (r2.www) * (r4.xyz);
    r1.xyz = (r1.xyz) * (c2.xxx);
    r2.xyz = (r2.xyz) * (r2.xyz) + (r4.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz);
    r1.xyz = (r3.zzz) * (r1.xyz);
    r2 = tex2D(s4, v1.xy);
    r3.z = max(abs(r5.y), abs(r5.z));
    r4.w = max(abs(r5.x), r3.z);
    r3.xyz = (r5.xyz) * (c[5].xyz);
    r4.w = 1.0f / (r4.w);
    r3.xyz = (r3.xyz) * (r4.www) + (v7.xyz);
    r4 = tex3D(s11, r3.xyz);
    r3.xy = (v1.xy) * (c[7].xy);
    r5 = tex2D(s3, r3.xy);
    r3.xyz = (r5.xyz) + (c0.xxx);
    r0.xyz = saturate((r3.xyz) * (r0.www) + (r0.xyz));
    r0.w = c0.y;
    r3.xyz = (r4.xyz) * (r4.xyz);
    r0 = float4(((r6.w) >= 0.0f ? (r0.x) : (c0.z)), ((r6.w) >= 0.0f ? (r0.y) : (c0.z)), ((r6.w) >= 0.0f ? (r0.z) : (c0.z)), ((r6.w) >= 0.0f ? (r0.w) : (c0.z)));
    r4.xyz = (r3.www) * (r3.xyz);
    r3.xyz = (r0.xyz) * (v0.xyz);
    r0.xyz = (r2.www) * (r4.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r2.xyz = (r0.xyz) * (c2.xxx) + (r1.xyz);
    r2.w = c0.y;
    r0.x = dot(r2, c[9]);
    r0.y = dot(r2, c[10]);
    r0.z = dot(r2, c[11]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r0.w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}

// Mechanically reconstructed from 0x4E48258C.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 0.200000003f, 8.0f, 31.875f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(1.0f, 3.5f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s1, v1.xy);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = v2;
    r0.xyz = (r1.xxx) * (v5.xyz) + (r0.xyz);
    r1.xyz = (r1.yyy) * (v4.xyz) + (r0.xyz);
    r0.xyz = normalize(r1.xyz);
    r6.xyz = normalize(v6.xyz);
    r1.w = saturate(dot(r0.xyz, -(r6.xyz)));
    r2.z = (-(r1.w)) + (c2.x);
    r2.y = (r2.z) * (r2.z);
    r1 = tex2D(s2, v1.xy);
    r2.w = (r1.w) * (c2.y) + (c2.x);
    r1.z = (r2.z) * (r2.y);
    r2.w = 1.0f / (r2.w);
    r3.w = (r1.z) * (r2.w);
    r2.xy = (v1.xy) * (c[6].xy);
    r2 = tex2D(s3, r2.xy);
    r3.xyz = (r2.xyz) + (c0.xxx);
    r2 = tex2D(s0, v1.xy);
    r2.xyz = saturate((r3.xyz) * (r2.www) + (r2.xyz));
    r3.xyz = lerp(r2.xyz, c0.yyy, r1.xxx);
    r4.xyz = (r1.xxx) * (r2.xyz);
    r2.xyz = (r3.xyz) * (-(r3.xyz)) + (c2.xxx);
    r1.z = dot(r6.xyz, r0.xyz);
    r5.xyz = (r3.www) * (r2.xyz);
    r1.z = (r1.z) + (r1.z);
    r2.xyz = (r0.xyz) * (-(r1.zzz)) + (r6.xyz);
    r2.w = (r1.w) * (c0.z);
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz) + (r5.xyz);
    r5.xyz = (r2.xyz) * (c0.zzz);
    r2 = tex3D(s11, v7.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r5.xyz) * (r2.xyz);
    r2.w = max(abs(r0.y), abs(r0.z));
    r2.xyz = (r2.xyz) * (c0.www);
    r1.w = max(abs(r0.x), r2.w);
    r0.xyz = (r0.xyz) * (c[5].xyz);
    r1.w = 1.0f / (r1.w);
    r3.xyz = (r3.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r1.www) + (v7.xyz);
    r2 = tex3D(s11, r0.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r4.xyz) * (v0.xyz);
    r0.xyz = (r1.yyy) * (r0.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r1.yyy) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r1.xyz = (r0.xyz) * (c0.www) + (r1.xyz);
    r1.w = c2.x;
    r0.x = dot(r1, c[8]);
    r0.y = dot(r1, c[9]);
    r0.z = dot(r1, c[10]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c2.x;

    return oC0;
}

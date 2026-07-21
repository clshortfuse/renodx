// Mechanically reconstructed from 0xD725EFE0.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler3D s11 : register(s11);

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
    const float4 c0 = float4(-2.0f, 3.0f, 31.875f, 1.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = (-(v4.xyz)) + (c[6].xyz);
    r2.y = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r2.y);
    r2.x = 1.0f / (r0.w);
    r1.xyz = (r0.xyz) * (r0.www);
    r0.w = dot(c[8].yz, r2.xy) + (c[8].x);
    r2.xy = saturate((r2.xx) * (c[9].xy) + (c[9].zw));
    r0.xy = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c0.xx) + (c0.yy);
    r0.xy = (r0.xy) * (r2.xy);
    r2.xyz = normalize(v2.xyz);
    r0.w = (r0.w) * (r0.x);
    r3.w = max(abs(r2.y), abs(r2.z));
    r1.w = (r0.y) * (r0.w);
    r0.w = max(abs(r2.x), r3.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r2.xyz) * (c[5].xyz);
    r1.z = saturate(dot(r1.xyz, r2.xyz));
    r0.xyz = (r0.xyz) * (r0.www) + (v5.xyz);
    r0 = tex3D(s11, r0.xyz);
    r1.w = (r1.w) * (r0.w);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r0.xyz) * (c0.zzz);
    r1.xyz = (r1.zzz) * (c[7].xyz);
    r0 = tex2D(s0, v1.xy);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1.xyz = (r1.www) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[10].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.w;

    return oC0;
}

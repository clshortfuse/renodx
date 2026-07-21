// Mechanically reconstructed from 0x78D6A778.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(7.0f, 8.0f, 31.875f, 1.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = normalize(v2.xyz);
    r1.xyz = normalize(v1.xyz);
    r0.w = dot(r1.xyz, r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r0.xyz) * (-(r0.www)) + (r1.xyz);
    r0 = texCUBE(s15, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.yyy);
    r1 = tex3D(s11, v4.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (c[20].xxx);
    r0.xyz = (r0.xyz) * (c0.zzz);
    r0.w = c[5].w;
    r1.xy = (r0.ww) * (c[10].xy);
    r1.xy = (r1.xy) * (c[11].xx);
    r1.xy = (v3.xy) * (c[11].xx) + (r1.xy);
    r1 = tex2D(s1, r1.xy);
    r2 = tex2D(s2, v3.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c0.xxx);
    r0.xyz = (r2.xyz) * (r1.xyz) + (r0.xyz);
    r0.w = c0.w;
    r1.x = dot(r0, c[7]);
    r1.y = dot(r0, c[8]);
    r1.z = dot(r0, c[9]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c0.w;

    return oC0;
}

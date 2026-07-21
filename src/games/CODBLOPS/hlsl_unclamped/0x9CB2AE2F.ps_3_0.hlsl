// Mechanically reconstructed from 0x9CB2AE2F.ps_3_0.cso.
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
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = c[20].w;
    r0.xy = (r0.ww) * (c[25].xy);
    r0.xy = (r0.xy) * (c[26].xx);
    r0.xy = (v3.xy) * (c[26].xx) + (r0.xy);
    r0 = tex2D(s1, r0.xy);
    r1 = tex2D(s2, v3.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c0.xxx);
    r2 = tex3D(s11, v4.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3.xyz = normalize(v1.xyz);
    r4.xyz = normalize(v2.xyz);
    r0.w = dot(r3.xyz, r4.xyz);
    r0.w = (r0.w) + (r0.w);
    r3.xyz = (r4.xyz) * (-(r0.www)) + (r3.xyz);
    r3 = texCUBE(s15, r3.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c0.yyy);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r2.xyz = (r2.xyz) * (c[27].xxx);
    r2.xyz = (r2.xyz) * (c0.zzz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r1 = (c[6]) + (-(v1.yyyy));
    r2 = (r1) * (r1);
    r3 = (c[5]) + (-(v1.xxxx));
    r2 = (r3) * (r3) + (r2);
    r5 = (c[7]) + (-(v1.zzzz));
    r2 = (r5) * (r5) + (r2);
    r6.x = rsqrt(r2.x);
    r6.y = rsqrt(r2.y);
    r6.z = rsqrt(r2.z);
    r6.w = rsqrt(r2.w);
    r0.w = c0.w;
    r2 = saturate((r2) * (c[8]) + (r0.wwww));
    r1 = (r1) * (r6);
    r1 = (r4.yyyy) * (r1);
    r3 = (r3) * (r6);
    r5 = (r5) * (r6);
    r1 = (r3) * (r4.xxxx) + (r1);
    r1 = saturate((r5) * (r4.zzzz) + (r1));
    r1 = (r2) * (r1);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r2.z = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r0.xyz);
    r0.w = c0.w;
    r1.x = dot(r0, c[22]);
    r1.y = dot(r0, c[23]);
    r1.z = dot(r0, c[24]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c0.w;

    return oC0;
}

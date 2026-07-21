// Mechanically reconstructed from 0x80F43853.ps_3_0.cso.
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
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = (-(v4.xyz)) + (c[21].xyz);
    r2.y = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r2.y);
    r2.x = 1.0f / (r0.w);
    r7.xyz = (r0.xyz) * (r0.www);
    r1.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r0.w = dot(c[23].yz, r2.xy) + (c[23].x);
    r0.xy = (r1.xy) * (r1.xy);
    r1.xy = (r1.xy) * (c0.xx) + (c0.yy);
    r6.xyz = normalize(v2.xyz);
    r1.xy = (r0.xy) * (r1.xy);
    r1.w = max(abs(r6.y), abs(r6.z));
    r0.w = (r0.w) * (r1.x);
    r0.z = max(abs(r6.x), r1.w);
    r1.w = 1.0f / (r0.z);
    r0.xyz = (r6.xyz) * (c[5].xyz);
    r0.w = (r1.y) * (r0.w);
    r0.xyz = (r0.xyz) * (r1.www) + (v5.xyz);
    r4 = tex3D(s11, r0.xyz);
    r5.w = (r0.w) * (r4.w);
    r3 = (-(v4.yyyy)) + (c[7]);
    r0 = (r3) * (r3);
    r2 = (-(v4.xxxx)) + (c[6]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v4.zzzz)) + (c[8]);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r0 = (r1) * (r1) + (r0);
    r5.xyz = (r4.xyz) * (c0.zzz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r6.w = saturate(dot(r7.xyz, r6.xyz));
    r3 = (r3) * (r4);
    r3 = (r6.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r6.xxxx) + (r3);
    r3.x = c0.w;
    r0 = saturate((r0) * (c[9]) + (r3.xxxx));
    r1 = saturate((r1) * (r6.zzzz) + (r2));
    r3.xyz = (r6.www) * (c[22].xyz);
    r0 = (r0) * (r1);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r1 = tex2D(s0, v1.xy);
    r1.xyz = (r1.xyz) * (v0.xyz);
    r2.z = dot(c[20], r0);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r5.www) * (r3.xyz) + (r5.xyz);
    r2.xyz = (r2.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[25].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.w;

    return oC0;
}

// Mechanically reconstructed from 0x3185EF41.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

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
    const float4 c0 = float4(8.0f, 31.875f, 1.0f, 3.5f);
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

    r1 = tex3D(s11, v5.xyz);
    r0 = tex2D(s1, v1.xy);
    r3.xyz = normalize(v4.xyz);
    r8.xyz = normalize(v2.xyz);
    r1.w = dot(r3.xyz, r8.xyz);
    r1.w = (r1.w) + (r1.w);
    r2.w = (r0.w) * (c0.x);
    r2.xyz = (r8.xyz) * (-(r1.www)) + (r3.xyz);
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r2.xyz) * (c0.xxx);
    r1.w = saturate(dot(r8.xyz, -(r3.xyz)));
    r1.xyz = (r1.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (c0.yyy);
    r2.w = (-(r1.w)) + (c0.z);
    r1.w = (r0.w) * (c0.w) + (c0.z);
    r0.w = (r2.w) * (r2.w);
    r1.w = 1.0f / (r1.w);
    r0.w = (r2.w) * (r0.w);
    r0.w = (r1.w) * (r0.w);
    r2.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.zzz);
    r2.xyz = (r0.www) * (r2.xyz);
    r1.w = max(abs(r8.y), abs(r8.z));
    r2.xyz = (r0.xyz) * (r0.xyz) + (r2.xyz);
    r0.w = max(abs(r8.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r8.xyz) * (c[5].xyz);
    r1.xyz = (r1.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v5.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r6.xyz = (r1.xyz) * (c[21].xxx);
    r7.xyz = (r0.xyz) * (c[21].yyy);
    r4 = tex2D(s0, v1.xy);
    r3 = (-(v4.yyyy)) + (c[7]);
    r0 = (r3) * (r3);
    r2 = (-(v4.xxxx)) + (c[6]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v4.zzzz)) + (c[8]);
    r0 = (r1) * (r1) + (r0);
    r5.xyz = (r4.xyz) * (v0.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r5.xyz = (r5.xyz) * (r5.xyz);
    r3 = (r3) * (r4);
    r3 = (r8.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r8.xxxx) + (r3);
    r3.y = c0.z;
    r0 = saturate((r0) * (c[9]) + (r3.yyyy));
    r1 = saturate((r1) * (r8.zzzz) + (r2));
    r2.xyz = (r7.xyz) * (r5.xyz);
    r0 = (r0) * (r1);
    r2.xyz = (r2.xyz) * (c0.yyy) + (r6.xyz);
    r1.x = dot(c[10], r0);
    r1.y = dot(c[11], r0);
    r1.z = dot(c[20], r0);
    r0.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.z;

    return oC0;
}

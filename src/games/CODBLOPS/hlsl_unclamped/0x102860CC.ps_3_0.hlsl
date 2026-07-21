// Mechanically reconstructed from 0x102860CC.ps_3_0.cso.
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
    float4 r9 = 0.0f;
    float4 oC0 = 0.0f;

    r1 = tex3D(s11, v5.xyz);
    r0 = tex2D(s1, v1.xy);
    r3.xyz = normalize(v4.xyz);
    r9.xyz = normalize(v2.xyz);
    r1.w = dot(r3.xyz, r9.xyz);
    r1.w = (r1.w) + (r1.w);
    r2.w = (r0.w) * (c0.x);
    r2.xyz = (r9.xyz) * (-(r1.www)) + (r3.xyz);
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r2.xyz) * (c0.xxx);
    r1.w = saturate(dot(r9.xyz, -(r3.xyz)));
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
    r1.w = max(abs(r9.y), abs(r9.z));
    r2.xyz = (r0.xyz) * (r0.xyz) + (r2.xyz);
    r0.w = max(abs(r9.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r9.xyz) * (c[5].xyz);
    r1.xyz = (r1.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v5.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r7.xyz = (r1.xyz) * (c[21].xxx);
    r8.xyz = (r0.xyz) * (c[21].yyy);
    r0 = tex2D(s0, v1.xy);
    r4 = (-(v4.yyyy)) + (c[7]);
    r1 = (r4) * (r4);
    r3 = (-(v4.xxxx)) + (c[6]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v4.zzzz)) + (c[8]);
    r1 = (r2) * (r2) + (r1);
    r0 = (r0.wxyz) * (v0.wxyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r6.xyz = (r0.yzw) * (r0.yzw);
    r4 = (r4) * (r5);
    r4 = (r9.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r9.xxxx) + (r4);
    r0.y = c0.z;
    r1 = saturate((r1) * (c[9]) + (r0.yyyy));
    r2 = saturate((r2) * (r9.zzzz) + (r3));
    r3.xyz = (r8.xyz) * (r6.xyz);
    r1 = (r1) * (r2);
    r3.xyz = (r3.xyz) * (c0.yyy) + (r7.xyz);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r2.z = dot(c[20], r1);
    r1.xyz = (r6.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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

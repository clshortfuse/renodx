// Mechanically reconstructed from 0x386907AD.ps_3_0.cso.
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
    const float4 c0 = float4(31.875f, 1.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r7.xyz = normalize(v2.xyz);
    r1.w = max(abs(r7.y), abs(r7.z));
    r0.w = max(abs(r7.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r7.xyz) * (c[5].xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v5.xyz);
    r1 = tex3D(s11, r0.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r4 = (-(v4.yyyy)) + (c[7]);
    r0 = (r4) * (r4);
    r3 = (-(v4.xxxx)) + (c[6]);
    r0 = (r3) * (r3) + (r0);
    r2 = (-(v4.zzzz)) + (c[8]);
    r6.xyz = (r1.xyz) * (c0.xxx);
    r0 = (r2) * (r2) + (r0);
    r1.xyz = c[18].xyz;
    r1.xyz = (r1.xyz) * (c[21].xxx);
    r5.x = rsqrt(r0.x);
    r5.y = rsqrt(r0.y);
    r5.z = rsqrt(r0.z);
    r5.w = rsqrt(r0.w);
    r6.w = saturate(dot(c[17].xyz, r7.xyz));
    r4 = (r4) * (r5);
    r4 = (r7.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r7.xxxx) + (r4);
    r4.z = c0.y;
    r0 = saturate((r0) * (c[9]) + (r4.zzzz));
    r2 = saturate((r2) * (r7.zzzz) + (r3));
    r4.xyz = (r1.xyz) * (r6.www);
    r2 = (r0) * (r2);
    r3.x = dot(c[10], r2);
    r3.y = dot(c[11], r2);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r3.z = dot(c[20], r2);
    r1.xyz = (r0.yzw) * (r0.yzw);
    r2.xyz = (r1.www) * (r4.xyz) + (r6.xyz);
    r3.xyz = (r3.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r1.xyz = (r0.xxx) * (r1.xyz);
    r1.w = c0.y;
    r2.x = dot(r1, c[23]);
    r2.y = dot(r1, c[24]);
    r2.z = dot(r1, c[25]);
    r1.xyz = (v3.xyz) * (-(r0.xxx)) + (r2.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r1.xyz = (v3.xyz) * (r0.xxx) + (r1.xyz);
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

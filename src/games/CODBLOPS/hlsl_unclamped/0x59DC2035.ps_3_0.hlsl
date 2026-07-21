// Mechanically reconstructed from 0x59DC2035.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s12 : register(s12);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(-2.0f, 3.0f, 1.0f, -0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r3 = (-(v4.yyyy)) + (c[6]);
    r0 = (r3) * (r3);
    r2 = (-(v4.xxxx)) + (c[5]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v4.zzzz)) + (c[7]);
    r0 = (r1) * (r1) + (r0);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r3 = (r3) * (r4);
    r5.xyz = normalize(v2.xyz);
    r2 = (r2) * (r4);
    r3 = (r3) * (r5.yyyy);
    r1 = (r1) * (r4);
    r2 = (r2) * (r5.xxxx) + (r3);
    r3.y = c0.z;
    r0 = saturate((r0) * (c[8]) + (r3.yyyy));
    r1 = saturate((r1) * (r5.zzzz) + (r2));
    r0 = (r0) * (r1);
    r2.x = dot(c[9], r0);
    r2.y = dot(c[10], r0);
    r2.z = dot(c[11], r0);
    r0 = tex2D(s0, v1.xy);
    r3.xyz = (-(v4.xyz)) + (c[20].xyz);
    r6.y = dot(r3.xyz, r3.xyz);
    r0.xyz = (r0.xyz) * (v0.www);
    r1.w = rsqrt(r6.y);
    r0.xyz = (r0.www) * (r0.xyz);
    r6.x = 1.0f / (r1.w);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r4.xy = saturate((r6.xx) * (c[23].xy) + (c[23].zw));
    r1.xy = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c0.xx) + (c0.yy);
    r0.w = dot(c[22].yz, r6.xy) + (c[22].x);
    r4.xy = (r1.xy) * (r4.xy);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r0.w) * (r4.x);
    r3.xyz = (r3.xyz) * (r1.www);
    r1.w = (r4.y) * (r0.w);
    r0 = tex2D(s12, v1.zw);
    r0.z = saturate(dot(r3.xyz, r5.xyz));
    r0.w = (r1.w) * (r0.y);
    r0.xyz = (r0.zzz) * (c[21].xyz);
    r2.xyz = (r2.xyz) * (r1.xyz);
    r0.xyz = (r0.www) * (r0.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[24].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.w;

    return oC0;
}

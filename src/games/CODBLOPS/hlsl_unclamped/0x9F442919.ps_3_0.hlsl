// Mechanically reconstructed from 0x9F442919.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
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
    const float4 c0 = float4(-2.0f, 3.0f, 0.25f, 1.0f);
    const float4 c1 = float4(-0.0f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v4.ww) * (c[27].xy) + (v4.xy);
    r0.zw = v4.zw;
    r0 = tex2Dproj(s1, r0);
    r1.xy = (v4.ww) * (-(c[27].xy)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.y = r1.x;
    r1.xy = (v4.ww) * (c[27].zw) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.z = r1.x;
    r1.xy = (v4.ww) * (-(c[27].zw)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r2.xyz = (-(v5.xyz)) + (c[21].xyz);
    r3.y = dot(r2.xyz, r2.xyz);
    r0.w = r1.x;
    r1.w = rsqrt(r3.y);
    r1.z = dot(r0, c0.zzzz);
    r6.xyz = (r2.xyz) * (r1.www);
    r3.x = 1.0f / (r1.w);
    r5.xyz = normalize(v2.xyz);
    r0.w = dot(r6.xyz, c[23].xyz);
    r1.y = max(abs(r5.y), abs(r5.z));
    r1.w = saturate((r0.w) * (c[24].x) + (c[24].y));
    r0.w = max(abs(r5.x), r1.y);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r5.xyz) * (c[5].xyz);
    r1.w = (r1.w) * (c[24].w);
    r0.xyz = (r0.xyz) * (r0.www) + (v6.xyz);
    r0 = tex3D(s11, r0.xyz);
    r4.w = lerp(r0.w, r1.z, r1.w);
    r1.xy = saturate((r3.xx) * (c[26].xy) + (c[26].zw));
    r0.xy = (r1.xy) * (r1.xy);
    r1.xy = (r1.xy) * (c0.xx) + (c0.yy);
    r0.w = dot(c[25].yz, r3.xy) + (c[25].x);
    r4.xy = (r0.xy) * (r1.xy);
    r4.z = (r0.w) * (r4.x);
    r3 = (-(v5.yyyy)) + (c[7]);
    r0 = (r3) * (r3);
    r2 = (-(v5.xxxx)) + (c[6]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v5.zzzz)) + (c[8]);
    r4.z = (r4.y) * (r4.z);
    r0 = (r1) * (r1) + (r0);
    r5.w = (r4.w) * (r4.z);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r6.w = saturate(dot(r6.xyz, r5.xyz));
    r3 = (r3) * (r4);
    r3 = (r5.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r5.xxxx) + (r3);
    r3.x = c0.w;
    r0 = saturate((r0) * (c[9]) + (r3.xxxx));
    r1 = saturate((r1) * (r5.zzzz) + (r2));
    r3.xyz = (r6.www) * (c[22].xyz);
    r0 = (r0) * (r1);
    r1 = tex2D(s0, v1.xy);
    r1.xyz = (r1.xyz) * (v0.www);
    r2.x = dot(c[10], r0);
    r1.xyz = (r1.www) * (r1.xyz);
    r2.y = dot(c[11], r0);
    r1.xyz = (r1.xyz) * (v0.xyz);
    r2.z = dot(c[20], r0);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r5.www) * (r3.xyz);
    r2.xyz = (r2.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.x;

    return oC0;
}

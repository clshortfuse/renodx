// Mechanically reconstructed from 0xAE5F41D0.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s12 : register(s12);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(0.25f, -2.0f, 3.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v4.ww) * (c[11].xy) + (v4.xy);
    r0.zw = v4.zw;
    r0 = tex2Dproj(s1, r0);
    r1.xy = (v4.ww) * (-(c[11].xy)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.y = r1.x;
    r1.xy = (v4.ww) * (c[11].zw) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.z = r1.x;
    r1.xy = (v4.ww) * (-(c[11].zw)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.w = r1.x;
    r2.w = dot(r0, c0.xxxx);
    r0 = tex2D(s12, v1.zw);
    r1.xyz = (-(v5.xyz)) + (c[5].xyz);
    r4.y = dot(r1.xyz, r1.xyz);
    r0.w = rsqrt(r4.y);
    r1.xyz = (r1.xyz) * (r0.www);
    r4.x = 1.0f / (r0.w);
    r0.w = dot(r1.xyz, c[7].xyz);
    r0.z = saturate((r0.w) * (c[8].x) + (c[8].y));
    r3.xy = saturate((r4.xx) * (c[10].xy) + (c[10].zw));
    r2.xy = (r3.xy) * (r3.xy);
    r3.xy = (r3.xy) * (c0.yy) + (c0.zz);
    r0.w = dot(c[9].yz, r4.xy) + (c[9].x);
    r2.xy = (r2.xy) * (r3.xy);
    r0.z = (r0.z) * (c[8].w);
    r0.w = (r0.w) * (r2.x);
    r1.w = lerp(r0.y, r2.w, r0.z);
    r0.w = (r2.y) * (r0.w);
    r1.w = (r1.w) * (r0.w);
    r2.xyz = normalize(v2.xyz);
    r0 = tex2D(s0, v1.xy);
    r0.xyz = (r0.xyz) * (v0.www);
    r1.z = saturate(dot(r1.xyz, r2.xyz));
    r0.xyz = (r0.www) * (r0.xyz);
    r1.xyz = (r1.zzz) * (c[6].xyz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1.xyz = (r1.www) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.w;

    return oC0;
}

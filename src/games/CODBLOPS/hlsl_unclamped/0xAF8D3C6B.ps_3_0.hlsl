// Mechanically reconstructed from 0xAF8D3C6B.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(0.0f, 1.0f, 8.0f, 3.5f);
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c2 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v0.zw) * (c1.xy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v0.zw) * (c1.xy) + (c1.zy);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r1.xy = (r0.yw) * (c2.xx) + (c2.yy);
    r0.w = dot(r1.xy, r1.xy) + (c0.x);
    r0.w = exp2(-(r0.w));
    r1 = tex2D(s14, v0.zw);
    r4.xy = (r1.xy) * (c1.ww);
    r3.w = saturate((r0.w) * (c2.z) + (c2.w));
    r2.xy = (r2.xz) * (r4.yy);
    r0.w = (r1.y) * (c1.w) + (-(r2.x));
    r5.xz = (r2.xy) * (c2.xx);
    r0.w = (r2.z) * (-(r4.y)) + (r0.w);
    r0.xy = (r0.xz) * (r4.xx);
    r5.y = (r0.w) + (r0.w);
    r0.w = (r1.x) * (c1.w) + (-(r0.x));
    r3.xz = (r0.xy) * (c2.xx);
    r0.w = (r0.z) * (-(r4.x)) + (r0.w);
    r3.y = (r0.w) + (r0.w);
    r0.xy = c0.xy;
    r4.xy = (r0.xy) + (-(c[5].xy));
    r0 = tex2D(s1, v4.zw);
    r6.xyz = normalize(v3.xyz);
    r2.xyz = normalize(v1.xyz);
    r1.w = saturate(dot(r2.xyz, -(r6.xyz)));
    r2.w = (-(r1.w)) + (c0.y);
    r0.w = (r0.w) * (v4.y);
    r4.z = (r2.w) * (r2.w);
    r1 = tex2D(s2, v0.xy);
    r4.w = (r1.w) * (c0.w) + (c0.y);
    r2.w = (r2.w) * (r4.z);
    r4.w = 1.0f / (r4.w);
    r7.xy = (r0.ww) * (r4.xy) + (c[5].xy);
    r4.w = (r2.w) * (r4.w);
    r4.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.yyy);
    r2.w = dot(r6.xyz, r2.xyz);
    r4.xyz = (r4.www) * (r4.xyz);
    r4.w = (r2.w) + (r2.w);
    r2.w = (r1.w) * (c0.z);
    r2.xyz = (r2.xyz) * (-(r4.www)) + (r6.xyz);
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r4.xyz = (r1.xyz) * (r1.xyz) + (r4.xyz);
    r1.xyz = (r7.xxx) * (r2.xyz);
    r2.xyz = (r5.xyz) * (r3.www) + (r3.xyz);
    r1.xyz = (r4.xyz) * (r1.xyz);
    r2.xyz = (r7.yyy) * (r2.xyz);
    r4.xyz = (r3.xyz) * (r1.xyz);
    r1 = tex2D(s0, v0.xy);
    r3.xyz = lerp(r1.xyz, r0.xyz, r0.www);
    r1.xyz = (r4.xyz) * (c0.zzz);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[6].w;

    return oC0;
}

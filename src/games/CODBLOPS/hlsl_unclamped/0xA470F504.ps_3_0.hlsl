// Mechanically reconstructed from 0xA470F504.ps_3_0.cso.
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

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c1.xy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c1.xy) + (c1.zy);
    r2 = tex2D(s13, r0.xy);
    r1.w = r2.y;
    r0.xy = (r1.yw) * (c0.xx) + (c0.yy);
    r1.w = dot(r0.xy, r0.xy) + (c1.z);
    r0 = tex2D(s14, v1.zw);
    r3.xy = (r0.xy) * (c1.ww);
    r0.w = exp2(-(r1.w));
    r1.xy = (r1.xz) * (r3.xx);
    r2.w = saturate((r0.w) * (c0.z) + (c0.w));
    r0.w = (r0.x) * (c1.w) + (-(r1.x));
    r4.xz = (r1.xy) * (c0.xx);
    r0.w = (r1.z) * (-(r3.x)) + (r0.w);
    r4.y = (r0.w) + (r0.w);
    r1.xy = (r2.xz) * (r3.yy);
    r2.y = (r0.y) * (c1.w) + (-(r1.x));
    r3.xz = (r1.xy) * (c0.xx);
    r1 = tex2D(s0, v1.xy);
    r0 = tex2D(s1, v4.xy);
    r0.xyz = (r0.xyz) * (v0.yyy);
    r1.w = (r2.z) * (-(r3.y)) + (r2.y);
    r1.xyz = (r0.xyz) * (r0.www) + (r1.xyz);
    r0 = tex2D(s2, v4.zw);
    r0.xyz = (r0.xyz) * (v0.zzz);
    r3.y = (r1.w) + (r1.w);
    r0.xyz = (r0.xyz) * (r0.www) + (r1.xyz);
    r1.xyz = (r3.xyz) * (r2.www) + (r4.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (-(v3.xyz));
    r1.xyz = v3.xyz;
    r0.xyz = (v2.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[5].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.x;

    return oC0;
}

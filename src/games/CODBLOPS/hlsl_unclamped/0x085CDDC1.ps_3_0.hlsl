// Mechanically reconstructed from 0x085CDDC1.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

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
    const float4 c0 = float4(31.875f, 4.0f, -2.0f, 3.0f);
    const float4 c1 = float4(0.600000024f, 0.400000006f, 0.0f, 0.0f);
    const float4 c2 = float4(-1.0f, 1.0f, 0.5f, -0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v0.zw) * (c2.yz);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (c2.yz) + (c2.wz);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r3.xy = (r2.yw) * (c0.yy) + (c0.zz);
    r1 = tex2D(s14, v0.zw);
    r4.xy = (r1.xy) * (c0.xx);
    r0.w = dot(r3.xy, r3.xy) + (c2.w);
    r2.xy = (r2.xz) * (r4.xx);
    r0.y = exp2(-(r0.w));
    r0.w = (r1.x) * (c0.x) + (-(r2.x));
    r2.w = saturate((r0.y) * (c1.x) + (c1.y));
    r0.w = (r2.z) * (-(r4.x)) + (r0.w);
    r2.xz = (r2.xy) * (c0.yy);
    r2.y = (r0.w) + (r0.w);
    r0.xy = (r0.xz) * (r4.yy);
    r3.xyz = (-(v3.xyz)) + (c[5].xyz);
    r0.w = (r1.y) * (c0.x) + (-(r0.x));
    r5.y = dot(r3.xyz, r3.xyz);
    r1.xz = (r0.xy) * (c0.yy);
    r1.w = rsqrt(r5.y);
    r0.w = (r0.z) * (-(r4.y)) + (r0.w);
    r5.x = 1.0f / (r1.w);
    r1.y = (r0.w) + (r0.w);
    r4.xy = saturate((r5.xx) * (c[8].xy) + (c[8].zw));
    r0.xy = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c0.zz) + (c0.ww);
    r0.w = dot(c[7].yz, r5.xy) + (c[7].x);
    r0.xy = (r0.xy) * (r4.xy);
    r2.xyz = (r1.xyz) * (r2.www) + (r2.xyz);
    r0.w = (r0.w) * (r0.x);
    r1.xyz = (r3.xyz) * (r1.www);
    r1.w = (r0.y) * (r0.w);
    r0 = tex2D(s12, v0.zw);
    r3.xyz = normalize(v1.xyz);
    r1.w = (r1.w) * (r0.y);
    r1.z = saturate(dot(r1.xyz, r3.xyz));
    r0 = tex2D(s1, v4.zw);
    r0.xyz = (r0.xyz) + (c2.xxx);
    r1.xyz = (r1.zzz) * (c[6].xyz);
    r3.xyz = (v4.yyy) * (r0.xyz) + (c2.yyy);
    r0 = tex2D(s0, v0.xy);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r1.xyz = (r1.www) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c2.y;

    return oC0;
}

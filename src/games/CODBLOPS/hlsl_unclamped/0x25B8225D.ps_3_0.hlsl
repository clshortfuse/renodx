// Mechanically reconstructed from 0x25B8225D.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 0.5f);
    const float4 c1 = float4(31.875f, 4.0f, -2.0f, 3.0f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 0.0f, 0.0f);
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

    r0.xy = (v0.zw) * (c0.yw);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (c0.yw) + (c0.zw);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r1.xy = (r2.yw) * (c1.yy) + (c1.zz);
    r0.w = dot(r1.xy, r1.xy) + (c0.z);
    r1 = tex2D(s14, v0.zw);
    r4.xy = (r1.xy) * (c1.xx);
    r0.w = exp2(-(r0.w));
    r2.xy = (r2.xz) * (r4.xx);
    r2.w = saturate((r0.w) * (c2.x) + (c2.y));
    r0.w = (r1.x) * (c1.x) + (-(r2.x));
    r3.xz = (r2.xy) * (c1.yy);
    r0.xy = (r0.xz) * (r4.yy);
    r1.w = (r2.z) * (-(r4.x)) + (r0.w);
    r0.w = (r1.y) * (c1.x) + (-(r0.x));
    r3.y = (r1.w) + (r1.w);
    r0.w = (r0.z) * (-(r4.y)) + (r0.w);
    r1.xz = (r0.xy) * (c1.yy);
    r1.y = (r0.w) + (r0.w);
    r0 = tex2D(s0, v0.xy);
    r1.w = (r0.w) * (v4.x) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r3.xyz = (r1.xyz) * (r2.www) + (r3.xyz);
    r1 = float4(((r1.w) >= 0.0f ? (r0.x) : (c0.z)), ((r1.w) >= 0.0f ? (r0.y) : (c0.z)), ((r1.w) >= 0.0f ? (r0.z) : (c0.z)), ((r1.w) >= 0.0f ? (r0.w) : (c0.z)));
    r0 = tex2D(s1, v4.zw);
    r2.xyz = (-(v3.xyz)) + (c[20].xyz);
    r5.y = dot(r2.xyz, r2.xyz);
    r3.w = (r0.w) * (v4.y) + (c0.x);
    r2.w = rsqrt(r5.y);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r5.x = 1.0f / (r2.w);
    r0 = float4(((r3.w) >= 0.0f ? (r0.x) : (r1.x)), ((r3.w) >= 0.0f ? (r0.y) : (r1.y)), ((r3.w) >= 0.0f ? (r0.z) : (r1.z)), ((r3.w) >= 0.0f ? (r0.w) : (r1.w)));
    r4.xy = saturate((r5.xx) * (c[23].xy) + (c[23].zw));
    r1.xy = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c1.zz) + (c1.ww);
    r1.w = dot(c[22].yz, r5.xy) + (c[22].x);
    r1.xy = (r1.xy) * (r4.xy);
    r6.xyz = (r3.xyz) * (r0.www);
    r1.w = (r1.w) * (r1.x);
    r8.xyz = (r2.xyz) * (r2.www);
    r6.w = (r1.y) * (r1.w);
    r5 = tex2D(s12, v0.zw);
    r4 = (-(v3.yyyy)) + (c[6]);
    r1 = (r4) * (r4);
    r3 = (-(v3.xxxx)) + (c[5]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v3.zzzz)) + (c[7]);
    r6.w = (r6.w) * (r5.y);
    r1 = (r2) * (r2) + (r1);
    r7.xyz = normalize(v1.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r7.w = saturate(dot(r8.xyz, r7.xyz));
    r4 = (r4) * (r5);
    r4 = (r7.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r7.xxxx) + (r4);
    r4.z = c0.y;
    r1 = saturate((r1) * (c[8]) + (r4.zzzz));
    r2 = saturate((r2) * (r7.zzzz) + (r3));
    r3.xyz = (r7.www) * (c[21].xyz);
    r1 = (r1) * (r2);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r2.z = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r6.www) * (r3.xyz) + (r6.xyz);
    r2.xyz = (r2.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r1.x = v1.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[24].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}

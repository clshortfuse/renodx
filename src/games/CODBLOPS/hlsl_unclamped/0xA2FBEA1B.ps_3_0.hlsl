// Mechanically reconstructed from 0xA2FBEA1B.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 0.5f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 31.875f, 4.0f);
    const float4 c3 = float4(4.0f, -2.0f, 2.0f, 0.0f);
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

    r0.xy = (v1.zw) * (c1.yw);
    r5 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c1.yw) + (c1.zw);
    r2 = tex2D(s13, r0.xy);
    r5.w = r2.y;
    r3.xy = (r5.yw) * (c3.xx) + (c3.yy);
    r1.w = dot(r3.xy, r3.xy) + (c1.z);
    r0 = tex2D(s1, v1.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r1.z = c1.y;
    r0 = tex2D(s0, v1.xy);
    r2.y = (r0.w) * (v0.w) + (c1.x);
    r0.w = exp2(-(r1.w));
    r6.xyz = float3(((r2.y) >= 0.0f ? (r1.x) : (c1.z)), ((r2.y) >= 0.0f ? (r1.y) : (c1.z)), ((r2.y) >= 0.0f ? (r1.z) : (c1.z)));
    r2.w = (r0.w) * (c2.x) + (c2.y);
    r1.w = dot(r6.xy, r6.xy) + (c1.z);
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r1.w = exp2(-(r1.w));
    r0 = float4(((r2.y) >= 0.0f ? (r0.x) : (c1.z)), ((r2.y) >= 0.0f ? (r0.y) : (c1.z)), ((r2.y) >= 0.0f ? (r0.z) : (c1.z)), ((r2.y) >= 0.0f ? (r0.w) : (c1.z)));
    r7.w = (r1.w) * (c2.x) + (c2.y);
    r1 = tex2D(s14, v1.zw);
    r9.xy = (r1.xy) * (c2.zz);
    r2.w = (r2.w) * (r7.w);
    r2.xy = (r2.xz) * (r9.yy);
    r1.w = dot(r3.xy, r6.xy) + (c1.z);
    r1.z = (r1.y) * (c2.z) + (-(r2.x));
    r1.w = saturate((r1.w) * (r2.w) + (r2.w));
    r1.z = (r2.z) * (-(r9.y)) + (r1.z);
    r2.xz = (r2.xy) * (c2.ww);
    r2.y = (r1.z) + (r1.z);
    r8.xyz = (r1.www) * (r2.xyz);
    r5.xy = (r5.xz) * (r9.xx);
    r5.w = (r1.x) * (c2.z) + (-(r5.x));
    r4 = (-(v4.yyyy)) + (c[6]);
    r1 = (r4) * (r4);
    r3 = (-(v4.xxxx)) + (c[5]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v4.zzzz)) + (c[7]);
    r7.xz = (r7.ww) * (r5.xy);
    r1 = (r2) * (r2) + (r1);
    r6.w = (r5.z) * (-(r9.x)) + (r5.w);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r4 = (r4) * (r5);
    r9.xyz = normalize(v2.xyz);
    r3 = (r3) * (r5);
    r4 = (r4) * (r9.yyyy);
    r2 = (r2) * (r5);
    r3 = (r3) * (r9.xxxx) + (r4);
    r4.z = c1.y;
    r1 = saturate((r1) * (c[8]) + (r4.zzzz));
    r2 = saturate((r2) * (r9.zzzz) + (r3));
    r7.y = (r7.w) * (r6.w);
    r1 = (r1) * (r2);
    r3.xyz = (r7.xyz) * (c3.xzx) + (r8.xyz);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r2.z = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r6.zzz) * (r3.xyz);
    r2.xyz = (r2.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}

// Mechanically reconstructed from 0x35644D6C.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s4 : register(s4);
sampler2D s5 : register(s5);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD2;
    float4 v4 : TEXCOORD3;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
    float4 v7 : COLOR1;
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
    float4 v7 = input.v7;
    const float4 c0 = float4(2.0f, -1.0f, -0.5f, -0.0f);
    const float4 c1 = float4(0.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 3.5f, 1.0f);
    const float4 c4 = float4(31.875f, 4.0f, -2.0f, 0.0f);
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

    r0.xy = (v0.zw) * (-(c0.yz));
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (-(c0.yz)) + (-(c0.wz));
    r4 = tex2D(s13, r0.xy);
    r2.w = r4.y;
    r0 = tex2D(s3, v6.zw);
    r6.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0 = (c0.xxxx) * (v7) + (c0.yyyy);
    r3.xy = (r2.yw) * (c4.yy) + (c4.zz);
    r5.x = dot(r6.xy, r0.xy) + (c0.w);
    r1 = tex2D(s1, v0.xy);
    r0.xy = (r1.wy) * (c2.xy) + (c2.zw);
    r1 = tex2D(s0, v0.xy);
    r5.w = (r1.w) * (v6.x) + (c0.z);
    r5.y = dot(r6.xy, r0.zw) + (c0.w);
    r6.xy = float2(((r5.w) >= 0.0f ? (r0.x) : (c0.w)), ((r5.w) >= 0.0f ? (r0.y) : (c0.w)));
    r0 = tex2D(s2, v6.zw);
    r4.w = (r0.w) * (v6.y) + (c0.z);
    r0.w = dot(r3.xy, r3.xy) + (c0.w);
    r6.xy = float2(((r4.w) >= 0.0f ? (r5.x) : (r6.x)), ((r4.w) >= 0.0f ? (r5.y) : (r6.y)));
    r0.w = exp2(-(r0.w));
    r1.w = dot(r6.xy, r6.xy) + (c0.w);
    r0.w = (r0.w) * (c3.x) + (c3.y);
    r2.w = exp2(-(r1.w));
    r1 = (r1.xyzx) * (-(c0.yyyw)) + (-(c0.wwwy));
    r2.w = (r2.w) * (c3.x) + (c3.y);
    r2.y = (r0.w) * (r2.w);
    r0.w = dot(r3.xy, r6.xy) + (c0.w);
    r3 = tex2D(s14, v0.zw);
    r7.xy = (r3.xy) * (c4.xx);
    r3.w = saturate((r0.w) * (r2.y) + (r2.y));
    r4.xy = (r4.xz) * (r7.yy);
    r0.w = (r3.y) * (c4.x) + (-(r4.x));
    r5.xz = (r4.xy) * (c4.yy);
    r0.w = (r4.z) * (-(r7.y)) + (r0.w);
    r2.xy = (r2.xz) * (r7.xx);
    r5.y = (r0.w) + (r0.w);
    r0.w = (r3.x) * (c4.x) + (-(r2.x));
    r3.xyz = (r3.www) * (r5.xyz);
    r0.w = (r2.z) * (-(r7.x)) + (r0.w);
    r7.xz = (r2.xy) * (c4.yy);
    r7.y = (r0.w) + (r0.w);
    r0 = (r0.xyzx) * (-(c0.yyyw)) + (-(c0.wwwy));
    r5.xyz = (r7.xyz) * (r2.www) + (r3.xyz);
    r2 = tex2D(s4, v0.xy);
    r2.xyz = (r2.wwy) * (c1.xyy) + (c1.zxx);
    r4.xyz = float3(((r5.w) >= 0.0f ? (r2.x) : (-(c0.w))), ((r5.w) >= 0.0f ? (r2.y) : (-(c0.y))), ((r5.w) >= 0.0f ? (r2.z) : (-(c0.w))));
    r2 = float4(((r5.w) >= 0.0f ? (r1.x) : (c0.w)), ((r5.w) >= 0.0f ? (r1.y) : (c0.w)), ((r5.w) >= 0.0f ? (r1.z) : (c0.w)), ((r5.w) >= 0.0f ? (r1.w) : (c0.w)));
    r1 = tex2D(s5, v6.zw);
    r3.xyz = (r1.wwy) * (c1.xyy) + (c1.zxx);
    r1 = v1;
    r1.xyz = (r6.xxx) * (v4.xyz) + (r1.xyz);
    r3.xyz = float3(((r4.w) >= 0.0f ? (r3.x) : (r4.x)), ((r4.w) >= 0.0f ? (r3.y) : (r4.y)), ((r4.w) >= 0.0f ? (r3.z) : (r4.z)));
    r1.xyz = (r6.yyy) * (v3.xyz) + (r1.xyz);
    r8.xyz = normalize(r1.xyz);
    r4.xyz = normalize(v5.xyz);
    r0 = float4(((r4.w) >= 0.0f ? (r0.x) : (r2.x)), ((r4.w) >= 0.0f ? (r0.y) : (r2.y)), ((r4.w) >= 0.0f ? (r0.z) : (r2.z)), ((r4.w) >= 0.0f ? (r0.w) : (r2.w)));
    r2.w = saturate(dot(r8.xyz, -(r4.xyz)));
    r1.xyz = (r5.xyz) * (r3.zzz);
    r2.w = (-(r2.w)) + (-(c0.y));
    r2.y = (r2.w) * (r2.w);
    r2.z = (r3.y) * (c3.z) + (c3.w);
    r2.w = (r2.w) * (r2.y);
    r2.z = 1.0f / (r2.z);
    r2.z = (r2.w) * (r2.z);
    r2.w = (r3.x) * (-(r3.x)) + (-(c0.y));
    r2.z = (r2.z) * (r2.w);
    r2.w = dot(r4.xyz, r8.xyz);
    r6.w = (r3.x) * (r3.x) + (r2.z);
    r2.w = (r2.w) + (r2.w);
    r2.xyz = (r8.xyz) * (-(r2.www)) + (r4.xyz);
    r2.w = (r3.y) * (c1.w);
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r6.xyz = (r3.zzz) * (r2.xyz);
    r5 = (-(v5.yyyy)) + (c[6]);
    r2 = (r5) * (r5);
    r4 = (-(v5.xxxx)) + (c[5]);
    r2 = (r4) * (r4) + (r2);
    r3 = (-(v5.zzzz)) + (c[7]);
    r6.xyz = (r6.www) * (r6.xyz);
    r2 = (r3) * (r3) + (r2);
    r7.xyz = (r7.xyz) * (r6.xyz);
    r6.x = rsqrt(r2.x);
    r6.y = rsqrt(r2.y);
    r6.z = rsqrt(r2.z);
    r6.w = rsqrt(r2.w);
    r7.xyz = (r7.xyz) * (c1.www);
    r5 = (r5) * (r6);
    r5 = (r8.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r8.xxxx) + (r5);
    r5.z = c0.y;
    r2 = saturate((r2) * (c[8]) + (-(r5.zzzz)));
    r3 = saturate((r3) * (r8.zzzz) + (r4));
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2 = (r2) * (r3);
    r3.xyz = (r0.xyz) * (r1.xyz) + (r7.xyz);
    r1.x = dot(c[9], r2);
    r1.y = dot(c[10], r2);
    r1.z = dot(c[11], r2);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v2.xyz);
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

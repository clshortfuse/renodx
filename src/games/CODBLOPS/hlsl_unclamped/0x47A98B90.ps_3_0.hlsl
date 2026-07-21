// Mechanically reconstructed from 0x47A98B90.ps_3_0.cso.
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
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD3;
    float4 v6 : TEXCOORD5;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 0.200000003f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 8.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 0.0f, 0.0f);
    const float4 c4 = float4(3.5f, 1.0f, 0.5f, 0.0f);
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

    r0 = tex2D(s1, v1.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s0, v1.xy);
    r3.w = (r0.w) * (v0.w) + (c1.x);
    r7.xy = float2(((r3.w) >= 0.0f ? (r1.x) : (c1.z)), ((r3.w) >= 0.0f ? (r1.y) : (c1.z)));
    r1 = v2;
    r1.xyz = (r7.xxx) * (v5.xyz) + (r1.xyz);
    r2.xyz = (r7.yyy) * (v4.xyz) + (r1.xyz);
    r1.xyz = normalize(r2.xyz);
    r3.xyz = normalize(v6.xyz);
    r2.w = saturate(dot(r1.xyz, -(r3.xyz)));
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r4.w = (-(r2.w)) + (c1.y);
    r2 = tex2D(s2, v1.xy);
    r2.xyz = (r2.wwy) * (c1.zyy) + (c1.wzz);
    r2.w = (r4.w) * (r4.w);
    r4.xyz = float3(((r3.w) >= 0.0f ? (r2.x) : (c1.z)), ((r3.w) >= 0.0f ? (r2.y) : (c1.y)), ((r3.w) >= 0.0f ? (r2.z) : (c1.z)));
    r2.w = (r4.w) * (r2.w);
    r2.z = (r4.y) * (c4.x) + (c4.y);
    r0 = float4(((r3.w) >= 0.0f ? (r0.x) : (c1.z)), ((r3.w) >= 0.0f ? (r0.y) : (c1.z)), ((r3.w) >= 0.0f ? (r0.z) : (c1.z)), ((r3.w) >= 0.0f ? (r0.w) : (c1.z)));
    r2.z = 1.0f / (r2.z);
    r2.z = (r2.w) * (r2.z);
    r2.w = (r4.x) * (-(r4.x)) + (c1.y);
    r2.z = (r2.z) * (r2.w);
    r2.w = dot(r3.xyz, r1.xyz);
    r4.w = (r4.x) * (r4.x) + (r2.z);
    r2.w = (r2.w) + (r2.w);
    r2.xyz = (r1.xyz) * (-(r2.www)) + (r3.xyz);
    r2.w = (r4.y) * (c2.z);
    r2 = texCUBElod(s15, r2);
    r1.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r4.zzz) * (r1.xyz);
    r2.xy = (v1.zw) * (c4.yz);
    r2 = tex2D(s13, r2.xy);
    r3 = tex2D(s14, v1.zw);
    r4.xy = (r3.xy) * (c2.ww);
    r6.xyz = (r4.www) * (r1.xyz);
    r1.xy = (r2.xz) * (r4.xx);
    r1.z = (r3.x) * (c2.w) + (-(r1.x));
    r5.xz = (r1.xy) * (c3.xx);
    r1.z = (r2.z) * (-(r4.x)) + (r1.z);
    r1.x = r2.y;
    r5.y = (r1.z) + (r1.z);
    r2.xy = (v1.zw) * (c4.yz) + (c4.wz);
    r2 = tex2D(s13, r2.xy);
    r8.xy = (r4.yy) * (r2.xz);
    r6.xyz = (r6.xyz) * (r5.xyz);
    r1.z = (r3.y) * (c2.w) + (-(r8.x));
    r3.xz = (r8.xy) * (c3.xx);
    r1.y = r2.y;
    r2.z = (r2.z) * (-(r4.y)) + (r1.z);
    r1.xy = (r1.xy) * (c3.xx) + (c3.yy);
    r2.w = dot(r1.xy, r1.xy) + (c1.z);
    r1.z = dot(r7.xy, r7.xy) + (c1.z);
    r2.w = exp2(-(r2.w));
    r1.z = exp2(-(r1.z));
    r2.y = (r2.w) * (c2.x) + (c2.y);
    r2.w = (r1.z) * (c2.x) + (c2.y);
    r1.z = dot(r1.xy, r7.xy) + (c1.z);
    r1.y = (r2.y) * (r2.w);
    r3.y = (r2.z) + (r2.z);
    r1.z = saturate((r1.z) * (r1.y) + (r1.y));
    r2.xyz = (r6.xyz) * (c2.zzz);
    r1.xyz = (r3.xyz) * (r1.zzz);
    r1.xyz = (r5.xyz) * (r2.www) + (r1.xyz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1.xyz = (r4.zzz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[5].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}

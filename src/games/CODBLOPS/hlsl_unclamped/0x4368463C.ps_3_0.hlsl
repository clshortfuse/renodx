// Mechanically reconstructed from 0x4368463C.ps_3_0.cso.
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
    float4 v7 : TEXCOORD6;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-0.5f, 0.0f, 1.0f, 8.0f);
    const float4 c2 = float4(0.959999979f, 0.0399999991f, 1.0f, 0.5f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c4 = float4(4.0f, -2.0f, 0.0f, 0.0f);
    const float4 c7 = float4(0.600000024f, 0.400000006f, 3.5f, 1.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c2.zw);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r3 = tex2D(s13, r1.xy);
    r0.w = r3.y;
    r1 = tex2D(s1, v1.xy);
    r4.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1 = tex2D(s3, v7.zw);
    r1.w = (r1.w) * (v0.z);
    r2.xy = (r0.yw) * (c4.xx) + (c4.yy);
    r7.xy = (r1.ww) * (-(r4.xy)) + (r4.xy);
    r0.y = dot(r2.xy, r2.xy) + (c1.y);
    r0.w = dot(r7.xy, r7.xy) + (c1.y);
    r0.y = exp2(-(r0.y));
    r0.w = exp2(-(r0.w));
    r0.y = (r0.y) * (c7.x) + (c7.y);
    r0.w = (r0.w) * (c7.x) + (c7.y);
    r3.w = (r0.y) * (r0.w);
    r0.y = dot(r2.xy, r7.xy) + (c1.y);
    r2 = tex2D(s14, v1.zw);
    r5.xy = (r2.xy) * (c3.ww);
    r2.z = saturate((r0.y) * (r3.w) + (r3.w));
    r3.xy = (r3.xz) * (r5.yy);
    r0.y = (r2.y) * (c3.w) + (-(r3.x));
    r4.xz = (r3.xy) * (c4.xx);
    r2.w = (r3.z) * (-(r5.y)) + (r0.y);
    r0.xy = (r0.xz) * (r5.xx);
    r4.y = (r2.w) + (r2.w);
    r2.w = (r2.x) * (c3.w) + (-(r0.x));
    r2.xyz = (r2.zzz) * (r4.xyz);
    r0.z = (r0.z) * (-(r5.x)) + (r2.w);
    r5.xz = (r0.xy) * (c4.xx);
    r5.y = (r0.z) + (r0.z);
    r6.xyz = (r5.xyz) * (r0.www) + (r2.xyz);
    r2 = tex2D(s2, v7.xy);
    r2.w = (r2.w) * (v0.y) + (c1.x);
    r4 = tex2D(s4, v1.xy);
    r0 = v2;
    r0.xyz = (r7.xxx) * (v5.xyz) + (r0.xyz);
    r3.xyz = (r7.yyy) * (v4.xyz) + (r0.xyz);
    r0.xyz = normalize(r3.xyz);
    r7.xyz = normalize(v6.xyz);
    r3.xy = float2(((r2.w) >= 0.0f ? (c1.y) : (r4.y)), ((r2.w) >= 0.0f ? (c1.z) : (r4.y)));
    r3.w = dot(r7.xyz, r0.xyz);
    r4.xy = lerp(r3.xy, c1.zz, r1.ww);
    r3.w = (r3.w) + (r3.w);
    r3.xyz = (r0.xyz) * (-(r3.www)) + (r7.xyz);
    r0.z = saturate(dot(r0.xyz, -(r7.xyz)));
    r3.w = (r4.w) * (c1.w);
    r0.x = (r4.w) * (c7.z) + (c7.w);
    r3 = texCUBElod(s15, r3);
    r0.z = (-(r0.z)) + (c1.z);
    r0.y = (r0.z) * (r0.z);
    r4.w = 1.0f / (r0.x);
    r3.w = (r0.z) * (r0.y);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r3.w = (r4.w) * (r3.w);
    r0.xyz = (r4.xxx) * (r0.xyz);
    r3.w = (r3.w) * (c2.x) + (c2.y);
    r4.xyz = (r6.xyz) * (r4.yyy);
    r0.xyz = (r0.xyz) * (r3.www);
    r3 = tex2D(s0, v1.xy);
    r3.xyz = float3(((r2.w) >= 0.0f ? (r2.x) : (r3.x)), ((r2.w) >= 0.0f ? (r2.y) : (r3.y)), ((r2.w) >= 0.0f ? (r2.z) : (r3.z)));
    r2.xyz = (r5.xyz) * (r0.xyz);
    r0.xyz = lerp(r3.xyz, r1.xyz, r1.www);
    r1.xyz = (r2.xyz) * (c1.www);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r4.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[5].w;

    return oC0;
}

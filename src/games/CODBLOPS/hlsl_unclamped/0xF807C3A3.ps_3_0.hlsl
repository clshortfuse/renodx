// Mechanically reconstructed from 0xF807C3A3.ps_3_0.cso.
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
    const float4 c1 = float4(-0.5f, 1.0f, -0.0f, 8.0f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 3.5f, 1.0f);
    const float4 c3 = float4(1.0f, 0.5f, -0.0f, 31.875f);
    const float4 c4 = float4(4.0f, -2.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v0.zw) * (c3.xy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v0.zw) * (c3.xy) + (c3.zy);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r3.xy = (r0.yw) * (c4.xx) + (c4.yy);
    r1 = tex2D(s1, v0.xy);
    r6.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r0.w = dot(r3.xy, r3.xy) + (c1.z);
    r0.y = dot(r6.xy, r6.xy) + (c1.z);
    r0.w = exp2(-(r0.w));
    r0.y = exp2(-(r0.y));
    r0.w = (r0.w) * (c2.x) + (c2.y);
    r4.w = (r0.y) * (c2.x) + (c2.y);
    r0.y = (r0.w) * (r4.w);
    r0.w = dot(r3.xy, r6.xy) + (c1.z);
    r1 = tex2D(s14, v0.zw);
    r4.xy = (r1.xy) * (c3.ww);
    r1.w = saturate((r0.w) * (r0.y) + (r0.y));
    r2.xy = (r2.xz) * (r4.yy);
    r0.w = (r1.y) * (c3.w) + (-(r2.x));
    r3.xz = (r2.xy) * (c4.xx);
    r0.w = (r2.z) * (-(r4.y)) + (r0.w);
    r0.xy = (r0.xz) * (r4.xx);
    r3.y = (r0.w) + (r0.w);
    r0.w = (r1.x) * (c3.w) + (-(r0.x));
    r5.xyz = (r1.www) * (r3.xyz);
    r0.w = (r0.z) * (-(r4.x)) + (r0.w);
    r4.xz = (r0.xy) * (c4.xx);
    r4.y = (r0.w) + (r0.w);
    r1 = tex2D(s2, v6.zw);
    r0 = v1;
    r0.xyz = (r6.xxx) * (v4.xyz) + (r0.xyz);
    r2.xyz = (r6.yyy) * (v3.xyz) + (r0.xyz);
    r0.xyz = normalize(r2.xyz);
    r3.xyz = normalize(v5.xyz);
    r2.w = saturate(dot(r0.xyz, -(r3.xyz)));
    r3.w = (-(r2.w)) + (c1.y);
    r1.w = (r1.w) * (v6.y) + (c1.x);
    r6.w = (r3.w) * (r3.w);
    r2 = tex2D(s3, v0.xy);
    r5.w = (r2.w) * (c2.z) + (c2.w);
    r3.w = (r3.w) * (r6.w);
    r5.w = 1.0f / (r5.w);
    r6.z = c1.y;
    r7.xy = float2(((r1.w) >= 0.0f ? (r6.z) : (c[5].x)), ((r1.w) >= 0.0f ? (r6.z) : (c[5].y)));
    r5.w = (r3.w) * (r5.w);
    r6.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.yyy);
    r3.w = dot(r3.xyz, r0.xyz);
    r6.xyz = (r5.www) * (r6.xyz);
    r5.w = (r3.w) + (r3.w);
    r3.w = (r2.w) * (c1.w);
    r3.xyz = (r0.xyz) * (-(r5.www)) + (r3.xyz);
    r3 = texCUBElod(s15, r3);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r2.xyz) * (r2.xyz) + (r6.xyz);
    r0.xyz = (r7.xxx) * (r0.xyz);
    r2.xyz = (r4.xyz) * (r4.www) + (r5.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r3.xyz = (r7.yyy) * (r2.xyz);
    r4.xyz = (r4.xyz) * (r0.xyz);
    r2 = tex2D(s0, v0.xy);
    r0.xyz = float3(((r1.w) >= 0.0f ? (r1.x) : (r2.x)), ((r1.w) >= 0.0f ? (r1.y) : (r2.y)), ((r1.w) >= 0.0f ? (r1.z) : (r2.z)));
    r1.xyz = (r4.xyz) * (c1.www);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.y;

    return oC0;
}

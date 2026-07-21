// Mechanically reconstructed from 0x52E478AE.ps_3_0.cso.
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
    const float4 c1 = float4(-0.5f, 0.0f, 1.0f, 0.200000003f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 8.0f, 31.875f);
    const float4 c3 = float4(3.5f, 1.0f, 0.5f, 0.0f);
    const float4 c4 = float4(4.0f, -2.0f, 0.0f, 0.0f);
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

    r0.xy = (v0.zw) * (c3.yz);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v0.zw) * (c3.yz) + (c3.wz);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r3.xy = (r0.yw) * (c4.xx) + (c4.yy);
    r1 = tex2D(s1, v0.xy);
    r4.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r0.w = dot(r3.xy, r3.xy) + (c1.y);
    r0.y = dot(r4.xy, r4.xy) + (c1.y);
    r0.w = exp2(-(r0.w));
    r0.y = exp2(-(r0.y));
    r0.w = (r0.w) * (c2.x) + (c2.y);
    r5.w = (r0.y) * (c2.x) + (c2.y);
    r0.y = (r0.w) * (r5.w);
    r0.w = dot(r3.xy, r4.xy) + (c1.y);
    r1 = tex2D(s14, v0.zw);
    r5.xy = (r1.xy) * (c2.ww);
    r1.w = saturate((r0.w) * (r0.y) + (r0.y));
    r2.xy = (r2.xz) * (r5.yy);
    r0.w = (r1.y) * (c2.w) + (-(r2.x));
    r3.xz = (r2.xy) * (c4.xx);
    r0.w = (r2.z) * (-(r5.y)) + (r0.w);
    r0.xy = (r0.xz) * (r5.xx);
    r3.y = (r0.w) + (r0.w);
    r0.w = (r1.x) * (c2.w) + (-(r0.x));
    r6.xyz = (r1.www) * (r3.xyz);
    r0.w = (r0.z) * (-(r5.x)) + (r0.w);
    r5.xz = (r0.xy) * (c4.xx);
    r5.y = (r0.w) + (r0.w);
    r2 = tex2D(s3, v0.xy);
    r1 = tex2D(s2, v6.zw);
    r0 = v1;
    r0.xyz = (r4.xxx) * (v4.xyz) + (r0.xyz);
    r3.xyz = (r4.yyy) * (v3.xyz) + (r0.xyz);
    r0.xyz = normalize(r3.xyz);
    r7.xyz = normalize(v5.xyz);
    r1.w = (r1.w) * (v6.y) + (c1.x);
    r2.z = dot(r7.xyz, r0.xyz);
    r8.xy = float2(((r1.w) >= 0.0f ? (c[5].x) : (r2.y)), ((r1.w) >= 0.0f ? (c[5].y) : (r2.y)));
    r2.z = (r2.z) + (r2.z);
    r4 = (r2.wwww) * (c1.yyyz) + (c1.wwwy);
    r3.xyz = (r0.xyz) * (-(r2.zzz)) + (r7.xyz);
    r2 = tex2D(s4, v6.zw);
    r2 = float4(((r1.w) >= 0.0f ? (r2.x) : (r4.x)), ((r1.w) >= 0.0f ? (r2.y) : (r4.y)), ((r1.w) >= 0.0f ? (r2.z) : (r4.z)), ((r1.w) >= 0.0f ? (r2.w) : (r4.w)));
    r0.z = saturate(dot(r0.xyz, -(r7.xyz)));
    r3.w = (r2.w) * (c2.z);
    r3 = texCUBElod(s15, r3);
    r0.z = (-(r0.z)) + (c1.z);
    r0.x = (r0.z) * (r0.z);
    r0.y = (r2.w) * (c3.x) + (c3.y);
    r0.z = (r0.z) * (r0.x);
    r0.y = 1.0f / (r0.y);
    r2.w = (r0.z) * (r0.y);
    r4.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.zzz);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r2.www) * (r4.xyz);
    r0.xyz = (r8.xxx) * (r0.xyz);
    r3.xyz = (r2.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r5.xyz) * (r5.www) + (r6.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r3.xyz = (r8.yyy) * (r2.xyz);
    r4.xyz = (r5.xyz) * (r0.xyz);
    r2 = tex2D(s0, v0.xy);
    r0.xyz = float3(((r1.w) >= 0.0f ? (r1.x) : (r2.x)), ((r1.w) >= 0.0f ? (r1.y) : (r2.y)), ((r1.w) >= 0.0f ? (r1.z) : (r2.z)));
    r1.xyz = (r4.xyz) * (c2.zzz);
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
    oC0.w = c1.z;

    return oC0;
}

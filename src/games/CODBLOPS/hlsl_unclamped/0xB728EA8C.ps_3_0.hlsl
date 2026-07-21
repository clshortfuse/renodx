// Mechanically reconstructed from 0xB728EA8C.ps_3_0.cso.
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
samplerCUBE s15 : register(s15);

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
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 8.0f);
    const float4 c1 = float4(31.875f, 4.0f, -2.0f, 0.0f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 0.0f, 0.0f);
    const float4 c3 = float4(3.5f, 1.0f, 0.5f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r1 = tex2D(s0, v1.xy);
    r0 = (r1.xyzx) * (c0.yyyz) + (c0.zzzy);
    r4.w = (r1.w) * (v0.w) + (c0.x);
    r1.xy = (v1.zw) * (c3.yz);
    r1 = tex2D(s13, r1.xy);
    r2.xy = (v1.zw) * (c3.yz) + (c3.wz);
    r3 = tex2D(s13, r2.xy);
    r1.w = r3.y;
    r0 = float4(((r4.w) >= 0.0f ? (r0.x) : (c0.z)), ((r4.w) >= 0.0f ? (r0.y) : (c0.z)), ((r4.w) >= 0.0f ? (r0.z) : (c0.z)), ((r4.w) >= 0.0f ? (r0.w) : (c0.z)));
    r2.xy = (r1.yw) * (c1.yy) + (c1.zz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1.w = dot(r2.xy, r2.xy) + (c0.z);
    r2 = tex2D(s14, v1.zw);
    r7.xy = (r2.xy) * (c1.xx);
    r1.w = exp2(-(r1.w));
    r3.xy = (r3.xz) * (r7.yy);
    r3.w = saturate((r1.w) * (c2.x) + (c2.y));
    r1.w = (r2.y) * (c1.x) + (-(r3.x));
    r5.xz = (r3.xy) * (c1.yy);
    r1.w = (r3.z) * (-(r7.y)) + (r1.w);
    r5.y = (r1.w) + (r1.w);
    r1.xy = (r1.xz) * (r7.xx);
    r1.w = (r2.x) * (c1.x) + (-(r1.x));
    r3.xz = (r1.xy) * (c1.yy);
    r6.xyz = normalize(v4.xyz);
    r4.xyz = normalize(v2.xyz);
    r1.z = (r1.z) * (-(r7.x)) + (r1.w);
    r1.w = dot(r6.xyz, r4.xyz);
    r3.y = (r1.z) + (r1.z);
    r1.w = (r1.w) + (r1.w);
    r1.y = c0.z;
    r7.xy = float2(((r4.w) >= 0.0f ? (c[5].x) : (r1.y)), ((r4.w) >= 0.0f ? (c[5].y) : (r1.y)));
    r2.xyz = (r4.xyz) * (-(r1.www)) + (r6.xyz);
    r1 = tex2D(s1, v1.xy);
    r1 = float4(((r4.w) >= 0.0f ? (r1.x) : (c0.z)), ((r4.w) >= 0.0f ? (r1.y) : (c0.z)), ((r4.w) >= 0.0f ? (r1.z) : (c0.z)), ((r4.w) >= 0.0f ? (r1.w) : (c0.y)));
    r4.w = saturate(dot(r4.xyz, -(r6.xyz)));
    r2.w = (r1.w) * (c0.w);
    r2 = texCUBElod(s15, r2);
    r4.w = (-(r4.w)) + (c0.y);
    r4.z = (r4.w) * (r4.w);
    r2.w = (r1.w) * (c3.x) + (c3.y);
    r1.w = (r4.w) * (r4.z);
    r2.w = 1.0f / (r2.w);
    r1.w = (r1.w) * (r2.w);
    r4.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.yyy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r4.xyz = (r1.www) * (r4.xyz);
    r2.xyz = (r7.xxx) * (r2.xyz);
    r4.xyz = (r1.xyz) * (r1.xyz) + (r4.xyz);
    r1.xyz = (r5.xyz) * (r3.www) + (r3.xyz);
    r2.xyz = (r2.xyz) * (r4.xyz);
    r1.xyz = (r7.yyy) * (r1.xyz);
    r2.xyz = (r3.xyz) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c0.www);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (c[6].w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}

// Mechanically reconstructed from 0xBEC464E0.ps_3_0.cso.
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
sampler2D s12 : register(s12);
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
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 8.0f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 0.797884583f, 31.875f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c4 = float4(0.0009765625f, 0.125f, 0.25f, 0.0f);
    const float4 c12 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c13 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c14 = float4(-2.0f, 3.0f, 0.0f, 0.0f);
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
    float4 r10 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v0.zw) * (c3.xy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v0.zw) * (c3.xy) + (c3.zy);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r3.xy = (r0.yw) * (c13.xx) + (c13.yy);
    r1 = tex2D(s1, v0.xy);
    r4.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r0.y = dot(r3.xy, r3.xy) + (c1.z);
    r0.w = dot(r4.xy, r4.xy) + (c1.z);
    r0.y = exp2(-(r0.y));
    r0.w = exp2(-(r0.w));
    r0.y = (r0.y) * (c2.x) + (c2.y);
    r0.w = (r0.w) * (c2.x) + (c2.y);
    r2.w = (r0.y) * (r0.w);
    r0.y = dot(r3.xy, r4.xy) + (c1.z);
    r1 = tex2D(s14, v0.zw);
    r5.xy = (r1.xy) * (c2.ww);
    r1.z = saturate((r0.y) * (r2.w) + (r2.w));
    r2.xy = (r2.xz) * (r5.yy);
    r0.y = (r1.y) * (c2.w) + (-(r2.x));
    r3.xz = (r2.xy) * (c3.ww);
    r1.w = (r2.z) * (-(r5.y)) + (r0.y);
    r0.xy = (r0.xz) * (r5.xx);
    r3.y = (r1.w) + (r1.w);
    r1.w = (r1.x) * (c2.w) + (-(r0.x));
    r1.xyz = (r1.zzz) * (r3.xyz);
    r0.z = (r0.z) * (-(r5.x)) + (r1.w);
    r3.xz = (r0.xy) * (c3.ww);
    r3.y = (r0.z) + (r0.z);
    r0.xyz = (r3.xyz) * (r0.www) + (r1.xyz);
    r1 = tex2D(s2, v6.zw);
    r6.xyz = (-(v5.xyz)) + (c[5].xyz);
    r7.y = dot(r6.xyz, r6.xyz);
    r7.w = rsqrt(r7.y);
    r7.x = 1.0f / (r7.w);
    r5.w = (r1.w) * (v6.y) + (c1.x);
    r5.xy = saturate((r7.xx) * (c[9].xy) + (c[9].zw));
    r2.xy = (r5.xy) * (r5.xy);
    r5.xy = (r5.xy) * (c14.xx) + (c14.yy);
    r0.w = dot(c[8].yz, r7.xy) + (c[8].x);
    r2.xy = (r2.xy) * (r5.xy);
    r1.w = c1.y;
    r9.xyz = float3(((r5.w) >= 0.0f ? (r1.w) : (c[10].x)), ((r5.w) >= 0.0f ? (r1.w) : (c[10].y)), ((r5.w) >= 0.0f ? (r1.w) : (c[10].w)));
    r0.w = (r0.w) * (r2.x);
    r5.xyz = (r0.xyz) * (r9.yyy);
    r1.w = (r2.y) * (r0.w);
    r2 = tex2D(s12, v0.zw);
    r0 = v1;
    r0.xyz = (r4.xxx) * (v4.xyz) + (r0.xyz);
    r4.xyz = (r4.yyy) * (v3.xyz) + (r0.xyz);
    r7.xyz = (r6.xyz) * (r7.www);
    r0.xyz = normalize(r4.xyz);
    r3.w = saturate(dot(r0.xyz, r7.xyz));
    r6.w = (r1.w) * (r2.y);
    r4.xyz = (r3.www) * (c[6].xyz);
    r2 = tex2D(s3, v0.xy);
    r8.z = (r2.w) * (c2.z);
    r10.xyz = normalize(v5.xyz);
    r8.w = (r2.w) * (-(c13.z)) + (c13.w);
    r1.w = saturate(dot(r0.xyz, -(r10.xyz)));
    r4.w = (r3.w) * (r8.w) + (r8.z);
    r8.w = (r1.w) * (r8.w) + (r8.z);
    r4.w = (r4.w) * (r8.w) + (c4.x);
    r8.xyz = (r6.xyz) * (r7.www) + (-(r10.xyz));
    r4.w = 1.0f / (r4.w);
    r6.xyz = normalize(r8.xyz);
    r7.w = (r3.w) * (r4.w);
    r8.w = saturate(dot(r0.xyz, r6.xyz));
    r4.w = saturate(dot(r6.xyz, r7.xyz));
    r6.xy = (r2.ww) * (c12.xy) + (c12.zw);
    r3.w = exp2(r6.y);
    r4.w = (-(r4.w)) + (c1.y);
    r6.y = pow(abs(r8.w), r3.w);
    r6.z = (r4.w) * (r4.w);
    r3.w = (r3.w) * (c4.y) + (c4.z);
    r6.z = (r6.z) * (r6.z);
    r3.w = (r6.y) * (r3.w);
    r4.w = (r4.w) * (r6.z);
    r8.xyz = (r2.xyz) * (r2.xyz);
    r7.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.yyy);
    r3.w = (r7.w) * (r3.w);
    r2.xyz = (r7.xyz) * (r4.www) + (r8.xyz);
    r4.xyz = (r6.www) * (r4.xyz) + (r5.xyz);
    r2.xyz = (r3.www) * (r2.xyz);
    r4.w = (-(r1.w)) + (c1.y);
    r2.xyz = (r9.zzz) * (r2.xyz);
    r3.w = 1.0f / (r6.x);
    r2.xyz = (r2.xyz) * (c[7].xyz);
    r1.w = (r2.w) * (c1.w);
    r5.xyz = (r6.www) * (r2.xyz);
    r2 = tex2D(s0, v0.xy);
    r2.w = dot(r10.xyz, r0.xyz);
    r2.w = (r2.w) + (r2.w);
    r6.xyz = float3(((r5.w) >= 0.0f ? (r1.x) : (r2.x)), ((r5.w) >= 0.0f ? (r1.y) : (r2.y)), ((r5.w) >= 0.0f ? (r1.z) : (r2.z)));
    r1.xyz = (r0.xyz) * (-(r2.www)) + (r10.xyz);
    r1 = texCUBElod(s15, r1);
    r0.z = (r4.w) * (r4.w);
    r1.w = (r4.w) * (r0.z);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r3.w) * (r1.w);
    r0.xyz = (r9.xxx) * (r0.xyz);
    r2.xyz = (r7.xyz) * (r1.www) + (r8.xyz);
    r1.xyz = (r6.xyz) * (r6.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r4.xyz) + (r5.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c1.www) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[11].w;

    return oC0;
}

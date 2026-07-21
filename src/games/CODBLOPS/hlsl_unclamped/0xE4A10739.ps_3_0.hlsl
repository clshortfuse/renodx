// Mechanically reconstructed from 0xE4A10739.ps_3_0.cso.
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
    const float4 c1 = float4(-0.5f, 0.0f, 0.600000024f, 0.400000006f);
    const float4 c2 = float4(8.0f, 1.0f, 0.797884583f, 0.5f);
    const float4 c3 = float4(0.959999979f, 0.0399999991f, 31.875f, 4.0f);
    const float4 c4 = float4(4.0f, -2.0f, 0.125f, 0.25f);
    const float4 c11 = float4(1.0f, 0.5f, 0.0f, 0.0009765625f);
    const float4 c12 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c13 = float4(-2.0f, 3.0f, 0.0f, 0.0f);
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

    r1.xyz = (-(v5.xyz)) + (c[5].xyz);
    r10.y = dot(r1.xyz, r1.xyz);
    r2.w = rsqrt(r10.y);
    r7.xyz = normalize(v5.xyz);
    r0.xyz = (r1.xyz) * (r2.www) + (-(r7.xyz));
    r5.xyz = (r1.xyz) * (r2.www);
    r4.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r4.xyz, r5.xyz));
    r1.w = (-(r0.w)) + (c2.y);
    r0.w = (r1.w) * (r1.w);
    r10.x = 1.0f / (r2.w);
    r1.z = (r0.w) * (r0.w);
    r0 = tex2D(s1, v0.xy);
    r8.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r1.w = (r1.w) * (r1.z);
    r0 = v1;
    r0.xyz = (r8.xxx) * (v4.xyz) + (r0.xyz);
    r4.w = (r1.w) * (c3.x) + (c3.y);
    r6.xyz = (r8.yyy) * (v3.xyz) + (r0.xyz);
    r3 = tex2D(s3, v0.xy);
    r2 = tex2D(s4, v6.zw);
    r1 = tex2D(s2, v6.zw);
    r1.w = (r1.w) * (v6.y) + (c1.x);
    r0.xyz = normalize(r6.xyz);
    r9.xy = float2(((r1.w) >= 0.0f ? (r2.w) : (r3.w)), ((r1.w) >= 0.0f ? (r2.y) : (r3.y)));
    r2.y = saturate(dot(r0.xyz, r5.xyz));
    r3.z = (r9.x) * (c2.z);
    r2.z = (r9.x) * (-(c2.z)) + (c2.y);
    r2.x = saturate(dot(r0.xyz, -(r7.xyz)));
    r2.w = (r2.y) * (r2.z) + (r3.z);
    r2.z = (r2.x) * (r2.z) + (r3.z);
    r6.w = (-(r2.x)) + (c2.y);
    r2.w = (r2.w) * (r2.z) + (c11.w);
    r2.z = 1.0f / (r2.w);
    r5.xy = (r9.xx) * (c12.xy) + (c12.zw);
    r3.z = saturate(dot(r0.xyz, r4.xyz));
    r3.w = exp2(r5.y);
    r2.x = pow(abs(r3.z), r3.w);
    r2.w = (r3.w) * (c4.z) + (c4.w);
    r2.z = (r2.y) * (r2.z);
    r2.w = (r2.x) * (r2.w);
    r6.xyz = (r2.yyy) * (c[6].xyz);
    r2.w = (r2.z) * (r2.w);
    r2.z = (r4.w) * (r2.w);
    r3.xy = saturate((r10.xx) * (c[9].xy) + (c[9].zw));
    r2.xy = (r3.xy) * (r3.xy);
    r3.xy = (r3.xy) * (c13.xx) + (c13.yy);
    r2.w = dot(c[8].yz, r10.xy) + (c[8].x);
    r2.xy = (r2.xy) * (r3.xy);
    r2.z = (r9.y) * (r2.z);
    r2.w = (r2.w) * (r2.x);
    r3.xyz = (r2.zzz) * (c[7].xyz);
    r3.w = (r2.y) * (r2.w);
    r2 = tex2D(s12, v0.zw);
    r4.w = (r3.w) * (r2.y);
    r5.w = 1.0f / (r5.x);
    r5.xyz = (r3.xyz) * (r4.www);
    r2 = tex2D(s0, v0.xy);
    r2.xyz = float3(((r1.w) >= 0.0f ? (r1.x) : (r2.x)), ((r1.w) >= 0.0f ? (r1.y) : (r2.y)), ((r1.w) >= 0.0f ? (r1.z) : (r2.z)));
    r1.xy = (v0.zw) * (c2.yw);
    r1 = tex2D(s13, r1.xy);
    r3.xy = (v0.zw) * (c11.xy) + (c11.zy);
    r3 = tex2D(s13, r3.xy);
    r1.w = r3.y;
    r4.xyz = (r2.xyz) * (r2.xyz);
    r2.xy = (r1.yw) * (c4.xx) + (c4.yy);
    r1.w = dot(r8.xy, r8.xy) + (c1.y);
    r1.y = dot(r2.xy, r2.xy) + (c1.y);
    r1.w = exp2(-(r1.w));
    r1.y = exp2(-(r1.y));
    r1.w = (r1.w) * (c1.z) + (c1.w);
    r2.w = (r1.y) * (c1.z) + (c1.w);
    r1.y = dot(r2.xy, r8.xy) + (c1.y);
    r3.w = (r1.w) * (r2.w);
    r2 = tex2D(s14, v0.zw);
    r10.xy = (r2.xy) * (c3.zz);
    r2.z = saturate((r1.y) * (r3.w) + (r3.w));
    r3.xy = (r3.xz) * (r10.yy);
    r1.y = (r2.y) * (c3.z) + (-(r3.x));
    r8.xz = (r3.xy) * (c3.ww);
    r2.w = (r3.z) * (-(r10.y)) + (r1.y);
    r1.xy = (r1.xz) * (r10.xx);
    r8.y = (r2.w) + (r2.w);
    r2.w = (r2.x) * (c3.z) + (-(r1.x));
    r3.xyz = (r2.zzz) * (r8.xyz);
    r1.z = (r1.z) * (-(r10.x)) + (r2.w);
    r2.xz = (r1.xy) * (c3.ww);
    r2.y = (r1.z) + (r1.z);
    r1.xyz = (r2.xyz) * (r1.www) + (r3.xyz);
    r1.w = dot(r7.xyz, r0.xyz);
    r3.xyz = (r9.yyy) * (r1.xyz);
    r1.w = (r1.w) + (r1.w);
    r1.xyz = (r0.xyz) * (-(r1.www)) + (r7.xyz);
    r1.w = (r9.x) * (c2.x);
    r1 = texCUBElod(s15, r1);
    r0.z = (r6.w) * (r6.w);
    r1.w = (r6.w) * (r0.z);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r5.w) * (r1.w);
    r0.xyz = (r9.yyy) * (r0.xyz);
    r1.w = (r1.w) * (c3.x) + (c3.y);
    r1.xyz = (r4.www) * (r6.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.www);
    r1.xyz = (r4.xyz) * (r1.xyz) + (r5.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c2.xxx) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[10].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c2.y;

    return oC0;
}

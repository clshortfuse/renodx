// Mechanically reconstructed from 0x2E8CCF67.ps_3_0.cso.
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
    const float4 c3 = float4(0.0009765625f, 0.125f, 0.25f, 0.0f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c8 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c9 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0 = tex2D(s0, v0.xy);
    r1.w = (r0.w) * (v6.x) + (c1.x);
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r1 = float4(((r1.w) >= 0.0f ? (r0.x) : (c1.z)), ((r1.w) >= 0.0f ? (r0.y) : (c1.z)), ((r1.w) >= 0.0f ? (r0.z) : (c1.z)), ((r1.w) >= 0.0f ? (r0.w) : (c1.z)));
    r2 = tex2D(s1, v6.zw);
    r0 = (r2.xyzx) * (c1.yyyz) + (c1.zzzy);
    r5.w = (r2.w) * (v6.y) + (c1.x);
    r0 = float4(((r5.w) >= 0.0f ? (r0.x) : (r1.x)), ((r5.w) >= 0.0f ? (r0.y) : (r1.y)), ((r5.w) >= 0.0f ? (r0.z) : (r1.z)), ((r5.w) >= 0.0f ? (r0.w) : (r1.w)));
    r9.xyz = float3(((r5.w) >= 0.0f ? (c[5].x) : (r1.w)), ((r5.w) >= 0.0f ? (c[5].y) : (r1.w)), ((r5.w) >= 0.0f ? (c[5].w) : (r1.w)));
    r1.xy = (v0.zw) * (c4.xy);
    r2 = tex2D(s13, r1.xy);
    r1.xy = (v0.zw) * (c4.xy) + (c4.zy);
    r3 = tex2D(s13, r1.xy);
    r2.w = r3.y;
    r1 = tex2D(s2, v6.zw);
    r1.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r4.xy = (r2.yw) * (c8.xx) + (c8.yy);
    r6.xy = float2(((r5.w) >= 0.0f ? (r1.x) : (c1.z)), ((r5.w) >= 0.0f ? (r1.y) : (c1.z)));
    r1.w = dot(r4.xy, r4.xy) + (c1.z);
    r1.z = dot(r6.xy, r6.xy) + (c1.z);
    r1.w = exp2(-(r1.w));
    r1.z = exp2(-(r1.z));
    r1.w = (r1.w) * (c2.x) + (c2.y);
    r2.w = (r1.z) * (c2.x) + (c2.y);
    r5.xyz = (r0.xyz) * (r0.xyz);
    r2.y = (r1.w) * (r2.w);
    r1 = tex2D(s14, v0.zw);
    r7.xy = (r1.xy) * (c2.ww);
    r0.z = dot(r4.xy, r6.xy) + (c1.z);
    r0.xy = (r3.xz) * (r7.yy);
    r1.w = saturate((r0.z) * (r2.y) + (r2.y));
    r1.z = (r1.y) * (c2.w) + (-(r0.x));
    r0.xz = (r0.xy) * (c4.ww);
    r0.y = (r3.z) * (-(r7.y)) + (r1.z);
    r0.y = (r0.y) + (r0.y);
    r2.xy = (r2.xz) * (r7.xx);
    r3.xyz = (r1.www) * (r0.xyz);
    r3.w = (r1.x) * (c2.w) + (-(r2.x));
    r4.xz = (r2.xy) * (c4.ww);
    r1 = v1;
    r0.xyz = (r6.xxx) * (v4.xyz) + (r1.xyz);
    r2.z = (r2.z) * (-(r7.x)) + (r3.w);
    r1.xyz = (r6.yyy) * (v3.xyz) + (r0.xyz);
    r4.y = (r2.z) + (r2.z);
    r0.xyz = normalize(r1.xyz);
    r1.xyz = (r4.xyz) * (r2.www) + (r3.xyz);
    r4.w = saturate(dot(r0.xyz, c[17].xyz));
    r3.xyz = (r9.yyy) * (r1.xyz);
    r1.xyz = (r4.www) * (c[18].xyz);
    r2 = tex2D(s12, v0.zw);
    r1.xyz = (r2.yyy) * (r1.xyz) + (r3.xyz);
    r3 = tex2D(s3, v6.zw);
    r3 = float4(((r5.w) >= 0.0f ? (r3.x) : (c1.z)), ((r5.w) >= 0.0f ? (r3.y) : (c1.z)), ((r5.w) >= 0.0f ? (r3.z) : (c1.z)), ((r5.w) >= 0.0f ? (r3.w) : (c1.y)));
    r2.w = dot(v5.xyz, v5.xyz);
    r5.w = (r3.w) * (c2.z);
    r6.w = rsqrt(r2.w);
    r2.x = (r3.w) * (-(c8.z)) + (c8.w);
    r10.xyz = (r6.www) * (v5.xyz);
    r2.z = (r4.w) * (r2.x) + (r5.w);
    r2.w = saturate(dot(r0.xyz, -(r10.xyz)));
    r7.xyz = (v5.xyz) * (-(r6.www)) + (c[17].xyz);
    r2.x = (r2.w) * (r2.x) + (r5.w);
    r2.w = (-(r2.w)) + (c1.y);
    r2.z = (r2.z) * (r2.x) + (c3.x);
    r2.z = 1.0f / (r2.z);
    r6.xyz = normalize(r7.xyz);
    r6.w = (r4.w) * (r2.z);
    r5.w = saturate(dot(r0.xyz, r6.xyz));
    r4.w = saturate(dot(r6.xyz, c[17].xyz));
    r6.xy = (r3.ww) * (c9.xy) + (c9.zw);
    r2.x = exp2(r6.y);
    r2.z = 1.0f / (r6.x);
    r6.z = pow(abs(r5.w), r2.x);
    r4.w = (-(r4.w)) + (c1.y);
    r2.x = (r2.x) * (c3.y) + (c3.z);
    r5.w = (r4.w) * (r4.w);
    r2.x = (r6.z) * (r2.x);
    r5.w = (r5.w) * (r5.w);
    r2.x = (r6.w) * (r2.x);
    r4.w = (r4.w) * (r5.w);
    r8.xyz = (r3.xyz) * (r3.xyz);
    r7.xyz = (r3.xyz) * (-(r3.xyz)) + (c1.yyy);
    r3.w = (r3.w) * (c1.w);
    r3.xyz = (r7.xyz) * (r4.www) + (r8.xyz);
    r3.xyz = (r2.xxx) * (r3.xyz);
    r2.x = dot(r10.xyz, r0.xyz);
    r3.xyz = (r9.zzz) * (r3.xyz);
    r2.x = (r2.x) + (r2.x);
    r6.xyz = (r3.xyz) * (c[19].xyz);
    r3.xyz = (r0.xyz) * (-(r2.xxx)) + (r10.xyz);
    r3 = texCUBElod(s15, r3);
    r0.z = (r2.w) * (r2.w);
    r2.w = (r2.w) * (r0.z);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r2.w = (r2.z) * (r2.w);
    r0.xyz = (r9.xxx) * (r0.xyz);
    r3.xyz = (r7.xyz) * (r2.www) + (r8.xyz);
    r2.xyz = (r2.yyy) * (r6.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r4.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c1.www) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v2.xyz);
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

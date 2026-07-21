// Mechanically reconstructed from 0xF358A068.ps_3_0.cso.
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
    const float4 c1 = float4(0.0f, 0.600000024f, 0.400000006f, 8.0f);
    const float4 c2 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c3 = float4(0.125f, 0.25f, 0.0f, 0.0f);
    const float4 c4 = float4(1.0f, 0.797884583f, 0.5f, 0.0f);
    const float4 c11 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0.xy = (v1.zw) * (c4.xz);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c4.xz) + (c4.wz);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r3.xy = (r0.yw) * (c2.yy) + (c2.zz);
    r1 = tex2D(s1, v1.xy);
    r5.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r0.y = dot(r3.xy, r3.xy) + (c1.x);
    r0.w = dot(r5.xy, r5.xy) + (c1.x);
    r0.y = exp2(-(r0.y));
    r0.w = exp2(-(r0.w));
    r0.y = (r0.y) * (c1.y) + (c1.z);
    r0.w = (r0.w) * (c1.y) + (c1.z);
    r2.w = (r0.y) * (r0.w);
    r0.y = dot(r3.xy, r5.xy) + (c1.x);
    r1 = tex2D(s14, v1.zw);
    r4.xy = (r1.xy) * (c2.xx);
    r1.z = saturate((r0.y) * (r2.w) + (r2.w));
    r2.xy = (r2.xz) * (r4.yy);
    r0.y = (r1.y) * (c2.x) + (-(r2.x));
    r3.xz = (r2.xy) * (c2.yy);
    r1.w = (r2.z) * (-(r4.y)) + (r0.y);
    r0.xy = (r0.xz) * (r4.xx);
    r3.y = (r1.w) + (r1.w);
    r1.w = (r1.x) * (c2.x) + (-(r0.x));
    r1.xyz = (r1.zzz) * (r3.xyz);
    r0.z = (r0.z) * (-(r4.x)) + (r1.w);
    r4.xz = (r0.xy) * (c2.yy);
    r4.y = (r0.z) + (r0.z);
    r0.xyz = (r4.xyz) * (r0.www) + (r1.xyz);
    r6.xyz = (r0.xyz) * (c[6].yyy);
    r1 = tex2D(s12, v1.zw);
    r0 = v2;
    r0.xyz = (r5.xxx) * (v5.xyz) + (r0.xyz);
    r2.xyz = (r5.yyy) * (v4.xyz) + (r0.xyz);
    r1.w = dot(v6.xyz, v6.xyz);
    r0.xyz = normalize(r2.xyz);
    r3.z = rsqrt(r1.w);
    r1.z = saturate(dot(r0.xyz, c[17].xyz));
    r9.xyz = (r3.zzz) * (v6.xyz);
    r5.xyz = (r1.zzz) * (c[18].xyz);
    r1.w = saturate(dot(r0.xyz, -(r9.xyz)));
    r2 = tex2D(s2, v1.xy);
    r3.y = (r2.w) * (c4.y);
    r1.x = (r2.w) * (-(c4.y)) + (c4.x);
    r3.w = (r1.w) * (r1.x) + (r3.y);
    r1.x = (r1.z) * (r1.x) + (r3.y);
    r7.xyz = (v6.xyz) * (-(r3.zzz)) + (c[17].xyz);
    r1.x = (r1.x) * (r3.w) + (c2.w);
    r1.x = 1.0f / (r1.x);
    r3.xyz = normalize(r7.xyz);
    r3.w = (r1.z) * (r1.x);
    r4.w = saturate(dot(r0.xyz, r3.xyz));
    r1.x = saturate(dot(r3.xyz, c[17].xyz));
    r10.xy = (r2.ww) * (c11.xy) + (c11.zw);
    r1.z = exp2(r10.y);
    r1.x = (-(r1.x)) + (c4.x);
    r3.y = pow(abs(r4.w), r1.z);
    r3.z = (r1.x) * (r1.x);
    r1.z = (r1.z) * (c3.x) + (c3.y);
    r3.z = (r3.z) * (r3.z);
    r1.z = (r3.y) * (r1.z);
    r1.x = (r1.x) * (r3.z);
    r8.xyz = (r2.xyz) * (r2.xyz);
    r7.xyz = (r2.xyz) * (-(r2.xyz)) + (c4.xxx);
    r1.z = (r3.w) * (r1.z);
    r3.xyz = (r7.xyz) * (r1.xxx) + (r8.xyz);
    r2.xyz = (r1.yyy) * (r5.xyz) + (r6.xyz);
    r3.xyz = (r1.zzz) * (r3.xyz);
    r5.w = (-(r1.w)) + (c4.x);
    r3.xyz = (r3.xyz) * (c[6].www);
    r4.w = 1.0f / (r10.x);
    r3.xyz = (r3.xyz) * (c[19].xyz);
    r1.w = (r2.w) * (c1.w);
    r5.xyz = (r1.yyy) * (r3.xyz);
    r3 = tex2D(s0, v1.xy);
    r1.z = dot(r9.xyz, r0.xyz);
    r1.z = (r1.z) + (r1.z);
    r6.xyz = (r3.xyz) * (v0.xyz);
    r1.xyz = (r0.xyz) * (-(r1.zzz)) + (r9.xyz);
    r1 = texCUBElod(s15, r1);
    r0.z = (r5.w) * (r5.w);
    r1.w = (r5.w) * (r0.z);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r4.w) * (r1.w);
    r0.xyz = (r0.xyz) * (c[6].xxx);
    r3.xyz = (r7.xyz) * (r1.www) + (r8.xyz);
    r1.xyz = (r6.xyz) * (r6.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r5.xyz);
    r0.xyz = (r4.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c1.www) + (r1.xyz);
    r2.x = c[5].w;
    r1.xy = (c[7].xy) * (-(r2.xx)) + (v1.xy);
    r1 = tex2D(s4, r1.xy);
    r2.xy = (c[8].xy) * (-(r2.xx)) + (v1.xy);
    r2 = tex2D(s3, r2.xy);
    r0.xyz = (r1.xyz) * (-(r2.xyz)) + (r0.xyz);
    r0.xyz = (r3.www) * (r0.xyz);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r0.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[10].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[9].w;

    return oC0;
}

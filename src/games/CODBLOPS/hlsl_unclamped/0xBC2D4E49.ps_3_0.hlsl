// Mechanically reconstructed from 0xBC2D4E49.ps_3_0.cso.
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
    const float4 c1 = float4(0.600000024f, 0.400000006f, 8.0f, 31.875f);
    const float4 c2 = float4(-1.0f, 1.0f, 0.200000003f, -0.0f);
    const float4 c3 = float4(4.0f, -2.0f, 0.0f, 0.0f);
    const float4 c4 = float4(3.5f, 1.0f, 0.5f, -0.0f);
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

    r0.xy = (v1.zw) * (c4.yz);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c4.yz) + (c4.wz);
    r3 = tex2D(s13, r1.xy);
    r0.w = r3.y;
    r1 = tex2D(s1, v1.xy);
    r4.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r2 = tex2D(s3, v7.zw);
    r2.w = (r2.w) * (v0.z);
    r1.xy = (r0.yw) * (c3.xx) + (c3.yy);
    r6.xy = (r2.ww) * (-(r4.xy)) + (r4.xy);
    r0.y = dot(r1.xy, r1.xy) + (c2.w);
    r0.w = dot(r6.xy, r6.xy) + (c2.w);
    r0.y = exp2(-(r0.y));
    r0.w = exp2(-(r0.w));
    r0.y = (r0.y) * (c1.x) + (c1.y);
    r0.w = (r0.w) * (c1.x) + (c1.y);
    r3.w = (r0.y) * (r0.w);
    r0.y = dot(r1.xy, r6.xy) + (c2.w);
    r1 = tex2D(s14, v1.zw);
    r5.xy = (r1.xy) * (c1.ww);
    r1.z = saturate((r0.y) * (r3.w) + (r3.w));
    r3.xy = (r3.xz) * (r5.yy);
    r0.y = (r1.y) * (c1.w) + (-(r3.x));
    r4.xz = (r3.xy) * (c3.xx);
    r1.w = (r3.z) * (-(r5.y)) + (r0.y);
    r0.xy = (r0.xz) * (r5.xx);
    r4.y = (r1.w) + (r1.w);
    r1.w = (r1.x) * (c1.w) + (-(r0.x));
    r1.xyz = (r1.zzz) * (r4.xyz);
    r0.z = (r0.z) * (-(r5.x)) + (r1.w);
    r7.xz = (r0.xy) * (c3.xx);
    r7.y = (r0.z) + (r0.z);
    r1.xyz = (r7.xyz) * (r0.www) + (r1.xyz);
    r5 = tex2D(s4, v1.xy);
    r0 = v2;
    r0.xyz = (r6.xxx) * (v5.xyz) + (r0.xyz);
    r10.xy = lerp(r5.yy, c[5].xy, r2.ww);
    r0.xyz = (r6.yyy) * (v4.xyz) + (r0.xyz);
    r8.xyz = normalize(r0.xyz);
    r9.xyz = normalize(v6.xyz);
    r0.z = dot(r9.xyz, r8.xyz);
    r6.xyz = (r1.xyz) * (r10.yyy);
    r3.w = (r0.z) + (r0.z);
    r4 = tex2D(s5, v7.zw);
    r1 = tex2D(s2, v7.xy);
    r0.xyz = (r1.xyz) + (c2.xxx);
    r0.xyz = (v0.yyy) * (r0.xyz) + (c2.yyy);
    r5.xyz = (r0.xyz) * (c2.zzz);
    r3.xyz = (r8.xyz) * (-(r3.www)) + (r9.xyz);
    r1 = lerp(r5, r4, r2.wwww);
    r4.w = saturate(dot(r8.xyz, -(r9.xyz)));
    r3.w = (r1.w) * (c1.z);
    r3 = texCUBElod(s15, r3);
    r4.w = (-(r4.w)) + (c2.y);
    r4.z = (r4.w) * (r4.w);
    r3.w = (r1.w) * (c4.x) + (c4.y);
    r1.w = (r4.w) * (r4.z);
    r3.w = 1.0f / (r3.w);
    r1.w = (r1.w) * (r3.w);
    r5.xyz = (r1.xyz) * (-(r1.xyz)) + (c2.yyy);
    r4.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r1.www) * (r5.xyz);
    r4.xyz = (r10.xxx) * (r4.xyz);
    r5.xyz = (r1.xyz) * (r1.xyz) + (r3.xyz);
    r1 = tex2D(s0, v1.xy);
    r3.xyz = (r1.xyz) * (-(r0.xyz)) + (r2.xyz);
    r2.xyz = (r4.xyz) * (r5.xyz);
    r3.xyz = (r2.www) * (r3.xyz);
    r2.xyz = (r7.xyz) * (r2.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r3.xyz);
    r1.xyz = (r2.xyz) * (c1.zzz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r6.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c2.y;

    return oC0;
}

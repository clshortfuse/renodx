// Mechanically reconstructed from 0x884D8ACA.ps_3_0.cso.
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
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD2;
    float4 v4 : TEXCOORD3;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
    float4 v7 : COLOR1;
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
    const float4 c2 = float4(2.0f, -1.0f, 0.0f, 1.0f);
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
    float4 r9 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v0.zw) * (c4.yz);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (c4.yz) + (c4.wz);
    r3 = tex2D(s13, r0.xy);
    r1.w = r3.y;
    r0 = tex2D(s1, v0.xy);
    r4.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s3, v6.zw);
    r5.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = (c2.xxxx) * (v7) + (c2.yyyy);
    r2.x = dot(r5.xy, r0.xy) + (c2.z);
    r2.y = dot(r5.xy, r0.zw) + (c2.z);
    r0 = tex2D(s2, v6.zw);
    r6.w = (r0.w) * (v6.y);
    r6.xy = (r1.yw) * (c3.xx) + (c3.yy);
    r5.xy = lerp(r4.xy, r2.xy, r6.ww);
    r1.w = dot(r6.xy, r6.xy) + (c2.z);
    r1.y = dot(r5.xy, r5.xy) + (c2.z);
    r1.w = exp2(-(r1.w));
    r1.y = exp2(-(r1.y));
    r1.w = (r1.w) * (c1.x) + (c1.y);
    r5.w = (r1.y) * (c1.x) + (c1.y);
    r2 = tex2D(s14, v0.zw);
    r4.xy = (r2.xy) * (c1.ww);
    r2.w = (r1.w) * (r5.w);
    r3.xy = (r3.xz) * (r4.yy);
    r1.w = dot(r6.xy, r5.xy) + (c2.z);
    r1.y = (r2.y) * (c1.w) + (-(r3.x));
    r1.w = saturate((r1.w) * (r2.w) + (r2.w));
    r1.y = (r3.z) * (-(r4.y)) + (r1.y);
    r3.xz = (r3.xy) * (c3.xx);
    r3.y = (r1.y) + (r1.y);
    r6.xyz = (r1.www) * (r3.xyz);
    r1.xy = (r1.xz) * (r4.xx);
    r1.w = (r2.x) * (c1.w) + (-(r1.x));
    r2.xyz = v1.xyz;
    r2.xyz = (r5.xxx) * (v4.xyz) + (r2.xyz);
    r5.xz = (r1.xy) * (c3.xx);
    r2.xyz = (r5.yyy) * (v3.xyz) + (r2.xyz);
    r7.xyz = normalize(r2.xyz);
    r8.xyz = normalize(v5.xyz);
    r5.y = (r1.z) * (-(r4.x)) + (r1.w);
    r1.w = dot(r8.xyz, r7.xyz);
    r1.xy = c[5].xy;
    r1.xy = (-(r1.xy)) + (c[6].xy);
    r1.w = (r1.w) + (r1.w);
    r9.xy = (r6.ww) * (r1.xy) + (c[5].xy);
    r2.xyz = (r7.xyz) * (-(r1.www)) + (r8.xyz);
    r4 = tex2D(s4, v0.xy);
    r3 = tex2D(s5, v6.zw);
    r1 = lerp(r4, r3, r6.wwww);
    r3.w = saturate(dot(r7.xyz, -(r8.xyz)));
    r2.w = (r1.w) * (c1.z);
    r2 = texCUBElod(s15, r2);
    r3.w = (-(r3.w)) + (c2.w);
    r3.z = (r3.w) * (r3.w);
    r2.w = (r1.w) * (c4.x) + (c4.y);
    r1.w = (r3.w) * (r3.z);
    r2.w = 1.0f / (r2.w);
    r1.w = (r1.w) * (r2.w);
    r3.xyz = (r1.xyz) * (-(r1.xyz)) + (c2.www);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3.xyz = (r1.www) * (r3.xyz);
    r2.xyz = (r9.xxx) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz) + (r3.xyz);
    r5.y = (r5.y) + (r5.y);
    r1.xyz = (r2.xyz) * (r1.xyz);
    r2.xyz = (r5.xyz) * (r5.www) + (r6.xyz);
    r1.xyz = (r5.xyz) * (r1.xyz);
    r2.xyz = (r9.yyy) * (r2.xyz);
    r3.xyz = (r1.xyz) * (c1.zzz);
    r1 = tex2D(s0, v0.xy);
    r4.xyz = lerp(r1.xyz, r0.xyz, r6.www);
    r1.w = (r1.w) * (-(v6.x)) + (c2.w);
    r0.w = (r0.w) * (-(v6.y)) + (c2.w);
    r0.xyz = (r4.xyz) * (r4.xyz);
    r0.w = (r1.w) * (-(r0.w)) + (c2.w);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r1.xyz = (r0.www) * (v2.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (-(r1.xyz));
    r0.xyz = (v1.www) * (r0.xyz) + (r1.xyz);
    r0.w = (r0.w) * (c[7].w);
    r0.xyz = max(((r0.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.w = rsqrt(r0.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}

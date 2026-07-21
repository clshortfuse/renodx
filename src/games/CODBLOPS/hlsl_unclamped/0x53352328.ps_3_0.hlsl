// Mechanically reconstructed from 0x53352328.ps_3_0.cso.
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
sampler2D s6 : register(s6);
sampler2D s7 : register(s7);
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
    float4 v8 : TEXCOORD7;
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
    float4 v8 = input.v8;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-1.0f, 1.0f, 0.0f, 8.0f);
    const float4 c2 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 0.0f, 0.0f);
    const float4 c4 = float4(0.600000024f, 0.400000006f, 3.5f, 1.0f);
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
    float4 r11 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s1, v1.xy);
    r0.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r2 = tex2D(s2, v7.xy);
    r7.w = (r2.w) * (v0.y);
    r0.xy = (r7.ww) * (-(r0.xy)) + (r0.xy);
    r1 = tex2D(s3, v7.zw);
    r2.w = (r1.w) * (v0.z);
    r10.xy = (r2.ww) * (-(r0.xy)) + (r0.xy);
    r0 = v2;
    r0.xyz = (r10.xxx) * (v5.xyz) + (r0.xyz);
    r3.xyz = (r10.yyy) * (v4.xyz) + (r0.xyz);
    r0.xyz = normalize(r3.xyz);
    r7.xyz = normalize(v6.xyz);
    r1.w = dot(r7.xyz, r0.xyz);
    r1.w = (r1.w) + (r1.w);
    r4.xyz = (r0.xyz) * (-(r1.www)) + (r7.xyz);
    r5 = tex2D(s5, v1.xy);
    r3 = tex2D(s6, v7.xy);
    r6 = lerp(r5, r3, r7.wwww);
    r5 = tex2D(s7, v7.zw);
    r3 = lerp(r6, r5, r2.wwww);
    r1.w = saturate(dot(r0.xyz, -(r7.xyz)));
    r4.w = (r3.w) * (c1.w);
    r4 = texCUBElod(s15, r4);
    r0.xyz = (r4.xyz) * (r4.xyz);
    r4.xy = c[5].xy;
    r4.xy = (-(r4.xy)) + (c[6].xy);
    r4.xy = (r7.ww) * (r4.xy) + (c[5].xy);
    r1.w = (-(r1.w)) + (c1.y);
    r9.xy = lerp(r4.xy, c[7].xy, r2.ww);
    r4.w = (r1.w) * (r1.w);
    r0.xyz = (r0.xyz) * (r9.xxx);
    r1.w = (r1.w) * (r4.w);
    r4 = tex2D(s4, v8.xy);
    r4.xyz = (r4.xyz) + (c1.xxx);
    r3.w = (r3.w) * (c4.z) + (c4.w);
    r6.xyz = (v0.www) * (r4.xyz) + (c1.yyy);
    r3.w = 1.0f / (r3.w);
    r5.xyz = (r3.xyz) * (r6.xyz);
    r1.w = (r1.w) * (r3.w);
    r3.xyz = (r5.xyz) * (-(r5.xyz)) + (c1.yyy);
    r7.xyz = (r1.www) * (r3.xyz);
    r3.xy = (v1.zw) * (c2.xy);
    r3 = tex2D(s13, r3.xy);
    r4 = tex2D(s14, v1.zw);
    r8.xy = (r4.xy) * (c2.ww);
    r5.xyz = (r5.xyz) * (r5.xyz) + (r7.xyz);
    r7.xy = (r3.xz) * (r8.xx);
    r5.xyz = (r0.xyz) * (r5.xyz);
    r0.z = (r4.x) * (c2.w) + (-(r7.x));
    r7.xz = (r7.xy) * (c3.xx);
    r0.z = (r3.z) * (-(r8.x)) + (r0.z);
    r0.x = r3.y;
    r7.y = (r0.z) + (r0.z);
    r5.xyz = (r5.xyz) * (r7.xyz);
    r3.xy = (v1.zw) * (c2.xy) + (c2.zy);
    r3 = tex2D(s13, r3.xy);
    r11.xy = (r8.yy) * (r3.xz);
    r5.xyz = (r5.xyz) * (c1.www);
    r0.z = (r4.y) * (c2.w) + (-(r11.x));
    r8.xz = (r11.xy) * (c3.xx);
    r0.y = r3.y;
    r3.w = (r3.z) * (-(r8.y)) + (r0.z);
    r0.xy = (r0.xy) * (c3.xx) + (c3.yy);
    r1.w = dot(r0.xy, r0.xy) + (c1.z);
    r0.z = dot(r10.xy, r10.xy) + (c1.z);
    r1.w = exp2(-(r1.w));
    r0.z = exp2(-(r0.z));
    r3.z = (r1.w) * (c4.x) + (c4.y);
    r1.w = (r0.z) * (c4.x) + (c4.y);
    r0.z = dot(r0.xy, r10.xy) + (c1.z);
    r0.y = (r3.z) * (r1.w);
    r8.y = (r3.w) + (r3.w);
    r0.z = saturate((r0.z) * (r0.y) + (r0.y));
    r3 = tex2D(s0, v1.xy);
    r4.xyz = lerp(r3.xyz, r2.xyz, r7.www);
    r2.xyz = (r8.xyz) * (r0.zzz);
    r0.xyz = lerp(r4.xyz, r1.xyz, r2.www);
    r1.xyz = (r7.xyz) * (r1.www) + (r2.xyz);
    r0.xyz = (r6.xyz) * (r0.xyz);
    r1.xyz = (r9.yyy) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r5.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[8].w;

    return oC0;
}

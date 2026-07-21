// Mechanically reconstructed from 0x31F2ED1E.ps_3_0.cso.
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
    const float4 c1 = float4(8.0f, 3.5f, 1.0f, 0.5f);
    const float4 c2 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 0.0f, 0.0f);
    const float4 c4 = float4(1.0f, 0.0f, 0.600000024f, 0.400000006f);
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

    r0.xy = (v1.zw) * (c1.zw);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c2.xy) + (c2.zy);
    r2 = tex2D(s13, r1.xy);
    r1 = tex2D(s1, v1.xy);
    r1.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r5 = tex2D(s2, v7.xy);
    r5.w = (r5.w) * (v0.y);
    r0.w = r2.y;
    r1.xy = (r5.ww) * (-(r1.xy)) + (r1.xy);
    r6 = tex2D(s3, v7.zw);
    r9.w = (r6.w) * (v0.z);
    r3.xy = (r0.yw) * (c3.xx) + (c3.yy);
    r7.xy = (r9.ww) * (-(r1.xy)) + (r1.xy);
    r0.w = dot(r3.xy, r3.xy) + (c4.y);
    r0.y = dot(r7.xy, r7.xy) + (c4.y);
    r0.w = exp2(-(r0.w));
    r0.y = exp2(-(r0.y));
    r0.w = (r0.w) * (c4.z) + (c4.w);
    r3.w = (r0.y) * (c4.z) + (c4.w);
    r1 = tex2D(s14, v1.zw);
    r8.xy = (r1.xy) * (c2.ww);
    r1.w = (r0.w) * (r3.w);
    r2.xy = (r2.xz) * (r8.yy);
    r0.w = dot(r3.xy, r7.xy) + (c4.y);
    r0.y = (r1.y) * (c2.w) + (-(r2.x));
    r0.w = saturate((r0.w) * (r1.w) + (r1.w));
    r0.y = (r2.z) * (-(r8.y)) + (r0.y);
    r2.xz = (r2.xy) * (c3.xx);
    r2.y = (r0.y) + (r0.y);
    r4.xyz = (r0.www) * (r2.xyz);
    r0.xy = (r0.xz) * (r8.xx);
    r0.w = (r1.x) * (c2.w) + (-(r0.x));
    r3.xz = (r0.xy) * (c3.xx);
    r3.y = (r0.z) * (-(r8.x)) + (r0.w);
    r0 = v2;
    r0.xyz = (r7.xxx) * (v5.xyz) + (r0.xyz);
    r6.w = c4.x;
    r1.xy = (r6.ww) + (-(c[20].xy));
    r0.xyz = (r7.yyy) * (v4.xyz) + (r0.xyz);
    r10.xyz = normalize(r0.xyz);
    r0.xyz = normalize(v6.xyz);
    r1.xy = (r5.ww) * (r1.xy) + (c[20].xy);
    r1.w = dot(r0.xyz, r10.xyz);
    r8.xy = lerp(r1.xy, c4.xx, r9.ww);
    r1.w = (r1.w) + (r1.w);
    r2.xyz = (r10.xyz) * (-(r1.www)) + (r0.xyz);
    r0.z = saturate(dot(r10.xyz, -(r0.xyz)));
    r1 = tex2D(s4, v1.xy);
    r2.w = (r1.w) * (c1.x);
    r2 = texCUBElod(s15, r2);
    r0.z = (-(r0.z)) + (c4.x);
    r0.x = (r0.z) * (r0.z);
    r0.y = (r1.w) * (c1.y) + (c1.z);
    r0.z = (r0.z) * (r0.x);
    r0.y = 1.0f / (r0.y);
    r1.w = (r0.z) * (r0.y);
    r7.xyz = (r1.xyz) * (-(r1.xyz)) + (c4.xxx);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r1.www) * (r7.xyz);
    r0.xyz = (r8.xxx) * (r0.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz) + (r2.xyz);
    r3.y = (r3.y) + (r3.y);
    r0.xyz = (r0.xyz) * (r1.xyz);
    r1.xyz = (r3.xyz) * (r3.www) + (r4.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r8.xyz = (r8.yyy) * (r1.xyz);
    r9.xyz = (r0.xyz) * (c1.xxx);
    r7 = tex2D(s0, v1.xy);
    r4 = (-(v6.yyyy)) + (c[6]);
    r1 = (r4) * (r4);
    r3 = (-(v6.xxxx)) + (c[5]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v6.zzzz)) + (c[7]);
    r1 = (r2) * (r2) + (r1);
    r11.xyz = lerp(r7.xyz, r5.xyz, r5.www);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r0.xyz = lerp(r11.xyz, r6.xyz, r9.www);
    r4 = (r4) * (r5);
    r4 = (r10.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r10.xxxx) + (r4);
    r1 = saturate((r1) * (c[8]) + (r6.wwww));
    r2 = saturate((r2) * (r10.zzzz) + (r3));
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1 = (r1) * (r2);
    r3.xyz = (r0.xyz) * (r8.xyz) + (r9.xyz);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r2.z = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c4.x;

    return oC0;
}

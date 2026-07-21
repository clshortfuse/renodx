// Mechanically reconstructed from 0x8140D6C5.ps_3_0.cso.
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
    const float4 c1 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c2 = float4(0.959999979f, 0.0399999991f, 1.0f, 0.5f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c4 = float4(0.0009765625f, 0.125f, 0.25f, 0.0f);
    const float4 c7 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c8 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c9 = float4(2.0f, -1.0f, 0.0f, 1.0f);
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

    r0.w = dot(v5.xyz, v5.xyz);
    r0.w = rsqrt(r0.w);
    r2.xyz = (v5.xyz) * (-(r0.www)) + (c[17].xyz);
    r8.xyz = (r0.www) * (v5.xyz);
    r0 = tex2D(s1, v0.xy);
    r5.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s3, v6.zw);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = (c9.xxxx) * (v7) + (c9.yyyy);
    r0.x = dot(r1.xy, r0.xy) + (c9.z);
    r0.y = dot(r1.xy, r0.zw) + (c9.z);
    r1 = tex2D(s2, v6.zw);
    r8.w = (r1.w) * (v6.y);
    r3.xyz = normalize(r2.xyz);
    r4.xy = lerp(r5.xy, r0.xy, r8.ww);
    r1.w = saturate(dot(r3.xyz, c[17].xyz));
    r0 = v1;
    r0.xyz = (r4.xxx) * (v4.xyz) + (r0.xyz);
    r1.w = (-(r1.w)) + (c9.w);
    r0.xyz = (r4.yyy) * (v3.xyz) + (r0.xyz);
    r2.w = (r1.w) * (r1.w);
    r7.xyz = normalize(r0.xyz);
    r3.w = (r2.w) * (r2.w);
    r0.x = saturate(dot(r7.xyz, -(r8.xyz)));
    r2 = tex2D(s4, v0.xy);
    r2.x = (r2.w) * (c1.w);
    r0.y = (r2.w) * (-(c7.z)) + (c7.w);
    r0.z = saturate(dot(r7.xyz, c[17].xyz));
    r2.z = (r0.x) * (r0.y) + (r2.x);
    r0.y = (r0.z) * (r0.y) + (r2.x);
    r1.w = (r1.w) * (r3.w);
    r0.y = (r0.y) * (r2.z) + (c4.x);
    r1.w = (r1.w) * (c2.x) + (c2.y);
    r0.y = 1.0f / (r0.y);
    r7.w = (-(r0.x)) + (c9.w);
    r0.y = (r0.z) * (r0.y);
    r6.xyz = (r0.zzz) * (c[18].xyz);
    r5.xy = (r2.ww) * (c8.xy) + (c8.zw);
    r2.x = saturate(dot(r7.xyz, r3.xyz));
    r2.z = exp2(r5.y);
    r0.x = pow(abs(r2.x), r2.z);
    r0.z = (r2.z) * (c4.y) + (c4.z);
    r0.z = (r0.x) * (r0.z);
    r0.x = -(r2.y);
    r0.z = (r0.y) * (r0.z);
    r0.y = (r0.x) + (c9.w);
    r0.z = (r1.w) * (r0.z);
    r10.xy = (r8.ww) * (r0.xy) + (r2.yy);
    r6.w = 1.0f / (r5.x);
    r0.z = (r0.z) * (r10.x);
    r1.w = (r2.w) * (c1.z);
    r9.xyz = (r0.zzz) * (c[19].xyz);
    r2 = tex2D(s12, v0.zw);
    r0.xy = (v0.zw) * (c2.zw);
    r3 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (c3.xy) + (c3.zy);
    r5 = tex2D(s13, r0.xy);
    r3.w = r5.y;
    r0.xy = (r3.yw) * (c7.xx) + (c7.yy);
    r2.w = dot(r4.xy, r4.xy) + (c9.z);
    r0.z = dot(r0.xy, r0.xy) + (c9.z);
    r2.w = exp2(-(r2.w));
    r0.z = exp2(-(r0.z));
    r2.w = (r2.w) * (c1.x) + (c1.y);
    r2.z = (r0.z) * (c1.x) + (c1.y);
    r0.z = dot(r0.xy, r4.xy) + (c9.z);
    r0.y = (r2.w) * (r2.z);
    r4 = tex2D(s14, v0.zw);
    r11.xy = (r4.xy) * (c3.ww);
    r2.x = saturate((r0.z) * (r0.y) + (r0.y));
    r0.xy = (r5.xz) * (r11.yy);
    r2.z = (r4.y) * (c3.w) + (-(r0.x));
    r0.xz = (r0.xy) * (c7.xx);
    r0.y = (r5.z) * (-(r11.y)) + (r2.z);
    r3.xy = (r3.xz) * (r11.xx);
    r0.y = (r0.y) + (r0.y);
    r2.z = (r4.x) * (c3.w) + (-(r3.x));
    r0.xyz = (r2.xxx) * (r0.xyz);
    r2.z = (r3.z) * (-(r11.x)) + (r2.z);
    r3.xz = (r3.xy) * (c7.xx);
    r3.y = (r2.z) + (r2.z);
    r0.xyz = (r3.xyz) * (r2.www) + (r0.xyz);
    r0.xyz = (r10.yyy) * (r0.xyz);
    r5.xyz = (r9.xyz) * (r2.yyy);
    r4.xyz = (r2.yyy) * (r6.xyz) + (r0.xyz);
    r2 = tex2D(s0, v0.xy);
    r0.z = dot(r8.xyz, r7.xyz);
    r0.z = (r0.z) + (r0.z);
    r6.xyz = lerp(r2.xyz, r1.xyz, r8.www);
    r1.xyz = (r7.xyz) * (-(r0.zzz)) + (r8.xyz);
    r1 = texCUBElod(s15, r1);
    r0.z = (r7.w) * (r7.w);
    r1.w = (r7.w) * (r0.z);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r6.w) * (r1.w);
    r0.xyz = (r10.xxx) * (r0.xyz);
    r1.w = (r1.w) * (c2.x) + (c2.y);
    r1.xyz = (r6.xyz) * (r6.xyz);
    r0.xyz = (r0.xyz) * (r1.www);
    r1.xyz = (r1.xyz) * (r4.xyz) + (r5.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c1.zzz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[5].w;

    return oC0;
}

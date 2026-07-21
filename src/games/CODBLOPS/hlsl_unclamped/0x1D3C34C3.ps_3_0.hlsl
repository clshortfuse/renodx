// Mechanically reconstructed from 0x1D3C34C3.ps_3_0.cso.
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
sampler2D s8 : register(s8);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD2;
    float4 v4 : TEXCOORD3;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
    float4 v7 : TEXCOORD7;
    float4 v8 : COLOR1;
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
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 8.0f, 31.875f);
    const float4 c3 = float4(3.5f, 1.0f, 0.5f, -0.0f);
    const float4 c4 = float4(4.0f, -2.0f, 0.0f, 0.0f);
    const float4 c11 = float4(2.0f, -1.0f, -0.0f, -0.200000003f);
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

    r0.xy = (v1.zw) * (c3.yz);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c3.yz) + (c3.wz);
    r4 = tex2D(s13, r0.xy);
    r0 = tex2D(s1, v1.xy);
    r3.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = tex2D(s5, v6.xy);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c11.xxxx) * (v8) + (c11.yyyy);
    r0.x = dot(r1.xy, r0.xy) + (c11.z);
    r0.y = dot(r1.xy, r0.zw) + (c11.z);
    r1 = tex2D(s2, v6.xy);
    r6.w = (r1.w) * (v0.y);
    r2.w = r4.y;
    r5.xy = lerp(r3.xy, r0.xy, r6.ww);
    r0 = tex2D(s3, v6.zw);
    r1.w = (r0.w) * (v0.z);
    r3.xy = (r2.yw) * (c4.xx) + (c4.yy);
    r7.xy = (r1.ww) * (-(r5.xy)) + (r5.xy);
    r2.w = dot(r3.xy, r3.xy) + (c11.z);
    r0.w = dot(r7.xy, r7.xy) + (c11.z);
    r2.w = exp2(-(r2.w));
    r0.w = exp2(-(r0.w));
    r2.w = (r2.w) * (c2.x) + (c2.y);
    r0.w = (r0.w) * (c2.x) + (c2.y);
    r2.y = (r2.w) * (r0.w);
    r2.w = dot(r3.xy, r7.xy) + (c11.z);
    r3 = tex2D(s14, v1.zw);
    r6.xy = (r3.xy) * (c2.ww);
    r3.w = saturate((r2.w) * (r2.y) + (r2.y));
    r4.xy = (r4.xz) * (r6.yy);
    r2.w = (r3.y) * (c2.w) + (-(r4.x));
    r5.xz = (r4.xy) * (c4.xx);
    r2.w = (r4.z) * (-(r6.y)) + (r2.w);
    r2.xy = (r2.xz) * (r6.xx);
    r5.y = (r2.w) + (r2.w);
    r2.w = (r3.x) * (c2.w) + (-(r2.x));
    r3.xyz = (r3.www) * (r5.xyz);
    r2.w = (r2.z) * (-(r6.x)) + (r2.w);
    r6.xz = (r2.xy) * (c4.xx);
    r6.y = (r2.w) + (r2.w);
    r2 = tex2D(s7, v6.xy);
    r4.xy = lerp(c[8].xy, r2.yy, r6.ww);
    r3.xyz = (r6.xyz) * (r0.www) + (r3.xyz);
    r9.xy = lerp(r4.xy, c[9].xy, r1.ww);
    r2 = (r2.wwww) * (-(c11.zzzy)) + (-(c11.wwwz));
    r5.xyz = (r3.xyz) * (r9.yyy);
    r3 = tex2D(s6, v1.xy);
    r4 = lerp(r3, r2, r6.wwww);
    r2 = tex2D(s8, v6.zw);
    r3.xyz = v2.xyz;
    r3.xyz = (r7.xxx) * (v4.xyz) + (r3.xyz);
    r3.xyz = (r7.yyy) * (v3.xyz) + (r3.xyz);
    r8.xyz = normalize(r3.xyz);
    r7.xyz = normalize(v5.xyz);
    r0.w = dot(r7.xyz, r8.xyz);
    r3 = lerp(r4, r2, r1.wwww);
    r0.w = (r0.w) + (r0.w);
    r2.w = (r3.w) * (c2.z);
    r2.xyz = (r8.xyz) * (-(r0.www)) + (r7.xyz);
    r4.w = saturate(dot(r8.xyz, -(r7.xyz)));
    r0.w = dot(c[5].xyz, r7.xyz);
    r2 = texCUBElod(s15, r2);
    r2.w = (-(r4.w)) + (-(c11.y));
    r4.w = (r2.w) * (r2.w);
    r2.w = (r2.w) * (r4.w);
    r4 = tex2D(s4, v7.xy);
    r4.xyz = (r4.xyz) + (c11.yyy);
    r3.w = (r3.w) * (c3.x) + (c3.y);
    r4.xyz = (v0.www) * (r4.xyz) + (-(c11.yyy));
    r3.w = 1.0f / (r3.w);
    r3.xyz = (r3.xyz) * (r4.xyz);
    r2.w = (r2.w) * (r3.w);
    r8.xyz = (r3.xyz) * (-(r3.xyz)) + (-(c11.yyy));
    r7.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r2.www) * (r8.xyz);
    r7.xyz = (r9.xxx) * (r7.xyz);
    r8.xyz = (r3.xyz) * (r3.xyz) + (r2.xyz);
    r2 = tex2D(s0, v1.xy);
    r3.xyz = lerp(r2.xyz, r1.xyz, r6.www);
    r1.xyz = (r7.xyz) * (r8.xyz);
    r2.xyz = lerp(r3.xyz, r0.xyz, r1.www);
    r1.xyz = (r6.xyz) * (r1.xyz);
    r0.xyz = (r4.xyz) * (r2.xyz);
    r2.xyz = (r1.xyz) * (c2.zzz);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.w = saturate((c[7].y) * (r0.w) + (c[7].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[6].xyz);
    r1.xyz = (r1.xyz) * (r5.xyz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[10].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = -(c11.y);

    return oC0;
}

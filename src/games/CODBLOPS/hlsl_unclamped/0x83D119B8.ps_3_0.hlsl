// Mechanically reconstructed from 0x83D119B8.ps_3_0.cso.
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
    float4 v7 : COLOR1;
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
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(2.0f, -1.0f, -0.5f, -0.0f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 8.0f, 31.875f);
    const float4 c4 = float4(3.5f, 1.0f, 4.0f, -2.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 oC0 = 0.0f;

    r1 = tex2D(s0, v1.xy);
    r0 = (r1.xyzx) * (-(c2.yyyw)) + (-(c2.wwwy));
    r7.y = (r1.w) * (v0.x) + (c2.z);
    r3 = float4(((r7.y) >= 0.0f ? (r0.x) : (c2.w)), ((r7.y) >= 0.0f ? (r0.y) : (c2.w)), ((r7.y) >= 0.0f ? (r0.z) : (c2.w)), ((r7.y) >= 0.0f ? (r0.w) : (c2.w)));
    r2 = tex2D(s2, v6.xy);
    r7.z = (r2.w) * (v0.y) + (c2.z);
    r0 = tex2D(s3, v6.zw);
    r7.w = (r0.w) * (v0.z) + (c2.z);
    r1 = tex2D(s1, v1.xy);
    r1.xy = (r1.wy) * (c1.xy) + (c1.zw);
    r1.zw = c[8].xy;
    r4 = float4(((r7.y) >= 0.0f ? (r1.x) : (c2.w)), ((r7.y) >= 0.0f ? (r1.y) : (c2.w)), ((r7.y) >= 0.0f ? (r1.z) : (c2.w)), ((r7.y) >= 0.0f ? (r1.w) : (c2.w)));
    r1.zw = c[9].xy;
    r5 = tex2D(s4, v6.xy);
    r6.xy = (r5.wy) * (c1.xy) + (c1.zw);
    r5 = (c2.xxxx) * (v7) + (c2.yyyy);
    r1.x = dot(r6.xy, r5.xy) + (c2.w);
    r1.y = dot(r6.xy, r5.zw) + (c2.w);
    r4 = float4(((r7.z) >= 0.0f ? (r1.x) : (r4.x)), ((r7.z) >= 0.0f ? (r1.y) : (r4.y)), ((r7.z) >= 0.0f ? (r1.z) : (r4.z)), ((r7.z) >= 0.0f ? (r1.w) : (r4.w)));
    r1.zw = c[10].xy;
    r5 = tex2D(s5, v6.zw);
    r6.xy = (r5.wy) * (c1.xy) + (c1.zw);
    r5 = (c2.xxxx) * (v8) + (c2.yyyy);
    r1.x = dot(r6.xy, r5.xy) + (c2.w);
    r1.y = dot(r6.xy, r5.zw) + (c2.w);
    r2 = (r2.xyzx) * (-(c2.yyyw)) + (-(c2.wwwy));
    r1 = float4(((r7.w) >= 0.0f ? (r1.x) : (r4.x)), ((r7.w) >= 0.0f ? (r1.y) : (r4.y)), ((r7.w) >= 0.0f ? (r1.z) : (r4.z)), ((r7.w) >= 0.0f ? (r1.w) : (r4.w)));
    r2 = float4(((r7.z) >= 0.0f ? (r2.x) : (r3.x)), ((r7.z) >= 0.0f ? (r2.y) : (r3.y)), ((r7.z) >= 0.0f ? (r2.z) : (r3.z)), ((r7.z) >= 0.0f ? (r2.w) : (r3.w)));
    r3.xyz = v2.xyz;
    r3.xyz = (r1.xxx) * (v4.xyz) + (r3.xyz);
    r0 = (r0.xyzx) * (-(c2.yyyw)) + (-(c2.wwwy));
    r3.xyz = (r1.yyy) * (v3.xyz) + (r3.xyz);
    r4.xyz = normalize(r3.xyz);
    r6.xyz = normalize(v5.xyz);
    r0 = float4(((r7.w) >= 0.0f ? (r0.x) : (r2.x)), ((r7.w) >= 0.0f ? (r0.y) : (r2.y)), ((r7.w) >= 0.0f ? (r0.z) : (r2.z)), ((r7.w) >= 0.0f ? (r0.w) : (r2.w)));
    r2.w = dot(r6.xyz, r4.xyz);
    r5.xyz = (r0.xyz) * (r0.xyz);
    r0.z = (r2.w) + (r2.w);
    r3.xyz = (r4.xyz) * (-(r0.zzz)) + (r6.xyz);
    r6.w = saturate(dot(r4.xyz, -(r6.xyz)));
    r2 = tex2D(s6, v1.xy);
    r4 = float4(((r7.y) >= 0.0f ? (r2.x) : (-(c2.w))), ((r7.y) >= 0.0f ? (r2.y) : (-(c2.w))), ((r7.y) >= 0.0f ? (r2.z) : (-(c2.w))), ((r7.y) >= 0.0f ? (r2.w) : (-(c2.y))));
    r2 = tex2D(s7, v6.xy);
    r4 = float4(((r7.z) >= 0.0f ? (r2.x) : (r4.x)), ((r7.z) >= 0.0f ? (r2.y) : (r4.y)), ((r7.z) >= 0.0f ? (r2.z) : (r4.z)), ((r7.z) >= 0.0f ? (r2.w) : (r4.w)));
    r2 = tex2D(s8, v6.zw);
    r2 = float4(((r7.w) >= 0.0f ? (r2.x) : (r4.x)), ((r7.w) >= 0.0f ? (r2.y) : (r4.y)), ((r7.w) >= 0.0f ? (r2.z) : (r4.z)), ((r7.w) >= 0.0f ? (r2.w) : (r4.w)));
    r5.w = dot(c[5].xyz, r6.xyz);
    r3.w = (r2.w) * (c3.z);
    r3 = texCUBElod(s15, r3);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r3.z = (-(r6.w)) + (-(c2.y));
    r3.y = (r3.z) * (r3.z);
    r3.w = (r2.w) * (c4.x) + (c4.y);
    r2.w = (r3.z) * (r3.y);
    r3.w = 1.0f / (r3.w);
    r2.w = (r2.w) * (r3.w);
    r3.xyz = (r2.xyz) * (-(r2.xyz)) + (-(c2.yyy));
    r0.xyz = (r1.zzz) * (r0.xyz);
    r3.xyz = (r2.www) * (r3.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz) + (r3.xyz);
    r3.xy = (v1.zw) * (-(c2.yz));
    r4 = tex2D(s13, r3.xy);
    r3 = tex2D(s14, v1.zw);
    r7.xy = (r3.xy) * (c3.ww);
    r6.xyz = (r0.xyz) * (r2.xyz);
    r0.xy = (r4.xz) * (r7.xx);
    r0.z = (r3.x) * (c3.w) + (-(r0.x));
    r3.xz = (r0.xy) * (c4.zz);
    r1.z = (r4.z) * (-(r7.x)) + (r0.z);
    r0.xy = (v1.zw) * (-(c2.yz)) + (-(c2.wz));
    r2 = tex2D(s13, r0.xy);
    r8.xy = (r7.yy) * (r2.xz);
    r0.x = r4.y;
    r0.z = (r3.y) * (c3.w) + (-(r8.x));
    r4.xz = (r8.xy) * (c4.zz);
    r0.y = r2.y;
    r2.z = (r2.z) * (-(r7.y)) + (r0.z);
    r0.xy = (r0.xy) * (c4.zz) + (c4.ww);
    r2.w = dot(r0.xy, r0.xy) + (c2.w);
    r0.z = dot(r1.xy, r1.xy) + (c2.w);
    r2.w = exp2(-(r2.w));
    r0.z = exp2(-(r0.z));
    r2.y = (r2.w) * (c3.x) + (c3.y);
    r2.w = (r0.z) * (c3.x) + (c3.y);
    r0.z = dot(r0.xy, r1.xy) + (c2.w);
    r0.y = (r2.y) * (r2.w);
    r4.y = (r2.z) + (r2.z);
    r0.z = saturate((r0.z) * (r0.y) + (r0.y));
    r3.y = (r1.z) + (r1.z);
    r0.xyz = (r4.xyz) * (r0.zzz);
    r1.xyz = (r6.xyz) * (r3.xyz);
    r0.xyz = (r3.xyz) * (r2.www) + (r0.xyz);
    r2.xyz = (r1.xyz) * (c3.zzz);
    r1.xyz = (r1.www) * (r0.xyz);
    r1.w = saturate((c[7].y) * (r5.w) + (c[7].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[6].xyz);
    r1.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r1.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (c[11].w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}

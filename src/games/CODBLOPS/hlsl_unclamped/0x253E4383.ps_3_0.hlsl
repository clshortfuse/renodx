// Mechanically reconstructed from 0x253E4383.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
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
    const float4 c1 = float4(-0.5f, 1.0f, -0.0f, 8.0f);
    const float4 c2 = float4(1.0f, 0.5f, -0.0f, 31.875f);
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
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c2.xy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c2.xy) + (c2.zy);
    r4 = tex2D(s13, r0.xy);
    r1.w = r4.y;
    r6.xy = (r1.yw) * (c3.xx) + (c3.yy);
    r0 = tex2D(s1, v1.xy);
    r2.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r2.zw = c[20].xy;
    r0 = tex2D(s0, v1.xy);
    r4.w = (r0.w) * (v0.w) + (c1.x);
    r0.w = dot(r6.xy, r6.xy) + (c1.z);
    r3 = float4(((r4.w) >= 0.0f ? (r2.x) : (c1.z)), ((r4.w) >= 0.0f ? (r2.y) : (c1.z)), ((r4.w) >= 0.0f ? (r2.z) : (c1.z)), ((r4.w) >= 0.0f ? (r2.w) : (c1.z)));
    r1.w = exp2(-(r0.w));
    r0.w = dot(r3.xy, r3.xy) + (c1.z);
    r1.w = (r1.w) * (c4.x) + (c4.y);
    r1.y = exp2(-(r0.w));
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r5.w = (r1.y) * (c4.x) + (c4.y);
    r2 = tex2D(s14, v1.zw);
    r5.xy = (r2.xy) * (c2.ww);
    r2.w = (r1.w) * (r5.w);
    r4.xy = (r4.xz) * (r5.yy);
    r1.w = dot(r6.xy, r3.xy) + (c1.z);
    r1.y = (r2.y) * (c2.w) + (-(r4.x));
    r1.w = saturate((r1.w) * (r2.w) + (r2.w));
    r1.y = (r4.z) * (-(r5.y)) + (r1.y);
    r4.xz = (r4.xy) * (c3.xx);
    r4.y = (r1.y) + (r1.y);
    r4.xyz = (r1.www) * (r4.xyz);
    r1.xy = (r1.xz) * (r5.xx);
    r1.w = (r2.x) * (c2.w) + (-(r1.x));
    r7.xz = (r1.xy) * (c3.xx);
    r2.w = (r1.z) * (-(r5.x)) + (r1.w);
    r1 = v2;
    r1.xyz = (r3.xxx) * (v5.xyz) + (r1.xyz);
    r7.y = (r2.w) + (r2.w);
    r1.xyz = (r3.yyy) * (v4.xyz) + (r1.xyz);
    r8.xyz = normalize(r1.xyz);
    r2.xyz = normalize(v6.xyz);
    r1.xyz = (r7.xyz) * (r5.www) + (r4.xyz);
    r2.w = dot(r2.xyz, r8.xyz);
    r1.xyz = (r3.www) * (r1.xyz);
    r2.w = (r2.w) + (r2.w);
    r4.xyz = (r8.xyz) * (-(r2.www)) + (r2.xyz);
    r3.w = saturate(dot(r8.xyz, -(r2.xyz)));
    r2 = tex2D(s2, v1.xy);
    r2 = float4(((r4.w) >= 0.0f ? (r2.x) : (c1.z)), ((r4.w) >= 0.0f ? (r2.y) : (c1.z)), ((r4.w) >= 0.0f ? (r2.z) : (c1.z)), ((r4.w) >= 0.0f ? (r2.w) : (c1.y)));
    r0 = float4(((r4.w) >= 0.0f ? (r0.x) : (c1.z)), ((r4.w) >= 0.0f ? (r0.y) : (c1.z)), ((r4.w) >= 0.0f ? (r0.z) : (c1.z)), ((r4.w) >= 0.0f ? (r0.w) : (c1.z)));
    r4.w = (r2.w) * (c1.w);
    r4 = texCUBElod(s15, r4);
    r3.y = (-(r3.w)) + (c1.y);
    r3.x = (r3.y) * (r3.y);
    r3.w = (r2.w) * (c4.z) + (c4.w);
    r2.w = (r3.y) * (r3.x);
    r3.w = 1.0f / (r3.w);
    r2.w = (r2.w) * (r3.w);
    r6.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.yyy);
    r5.xyz = (r4.xyz) * (r4.xyz);
    r4.xyz = (r2.www) * (r6.xyz);
    r3.xyz = (r3.zzz) * (r5.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz) + (r4.xyz);
    r6.xyz = (r3.xyz) * (r2.xyz);
    r5 = (-(v6.yyyy)) + (c[6]);
    r2 = (r5) * (r5);
    r4 = (-(v6.xxxx)) + (c[5]);
    r2 = (r4) * (r4) + (r2);
    r3 = (-(v6.zzzz)) + (c[7]);
    r6.xyz = (r7.xyz) * (r6.xyz);
    r2 = (r3) * (r3) + (r2);
    r7.xyz = (r6.xyz) * (c1.www);
    r6.x = rsqrt(r2.x);
    r6.y = rsqrt(r2.y);
    r6.z = rsqrt(r2.z);
    r6.w = rsqrt(r2.w);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r5 = (r5) * (r6);
    r5 = (r8.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r8.xxxx) + (r5);
    r5.z = c1.y;
    r2 = saturate((r2) * (c[8]) + (r5.zzzz));
    r3 = saturate((r3) * (r8.zzzz) + (r4));
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2 = (r2) * (r3);
    r3.xyz = (r0.xyz) * (r1.xyz) + (r7.xyz);
    r1.x = dot(c[9], r2);
    r1.y = dot(c[10], r2);
    r1.z = dot(c[11], r2);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}

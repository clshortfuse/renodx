// Mechanically reconstructed from 0x857C2E0F.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 8.0f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 3.5f, 1.0f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c4 = float4(4.0f, -2.0f, 0.0f, 0.0f);
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

    r0.xy = (v0.zw) * (c3.xy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (c3.xy) + (c3.zy);
    r4 = tex2D(s13, r0.xy);
    r1.w = r4.y;
    r7.xy = (r1.yw) * (c4.xx) + (c4.yy);
    r2 = tex2D(s2, v6.zw);
    r0 = tex2D(s0, v0.xy);
    r1.w = (r0.w) * (v6.x) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r2.xy = (r2.wy) * (c1.xy) + (c1.zw);
    r5 = float4(((r1.w) >= 0.0f ? (r0.x) : (c0.z)), ((r1.w) >= 0.0f ? (r0.y) : (c0.z)), ((r1.w) >= 0.0f ? (r0.z) : (c0.z)), ((r1.w) >= 0.0f ? (r0.w) : (c0.z)));
    r3 = (r5.wwww) * (c0.zzyy);
    r2.zw = c[20].xy;
    r0 = tex2D(s1, v6.zw);
    r4.w = (r0.w) * (v6.y) + (c0.x);
    r0.w = dot(r7.xy, r7.xy) + (c0.z);
    r3 = float4(((r4.w) >= 0.0f ? (r2.x) : (r3.x)), ((r4.w) >= 0.0f ? (r2.y) : (r3.y)), ((r4.w) >= 0.0f ? (r2.z) : (r3.z)), ((r4.w) >= 0.0f ? (r2.w) : (r3.w)));
    r1.w = exp2(-(r0.w));
    r0.w = dot(r3.xy, r3.xy) + (c0.z);
    r1.w = (r1.w) * (c2.x) + (c2.y);
    r1.y = exp2(-(r0.w));
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r6.w = (r1.y) * (c2.x) + (c2.y);
    r2 = tex2D(s14, v0.zw);
    r6.xy = (r2.xy) * (c3.ww);
    r2.w = (r1.w) * (r6.w);
    r4.xy = (r4.xz) * (r6.yy);
    r1.w = dot(r7.xy, r3.xy) + (c0.z);
    r1.y = (r2.y) * (c3.w) + (-(r4.x));
    r1.w = saturate((r1.w) * (r2.w) + (r2.w));
    r1.y = (r4.z) * (-(r6.y)) + (r1.y);
    r4.xz = (r4.xy) * (c4.xx);
    r4.y = (r1.y) + (r1.y);
    r4.xyz = (r1.www) * (r4.xyz);
    r1.xy = (r1.xz) * (r6.xx);
    r1.w = (r2.x) * (c3.w) + (-(r1.x));
    r7.xz = (r1.xy) * (c4.xx);
    r2.w = (r1.z) * (-(r6.x)) + (r1.w);
    r1 = v1;
    r1.xyz = (r3.xxx) * (v4.xyz) + (r1.xyz);
    r7.y = (r2.w) + (r2.w);
    r1.xyz = (r3.yyy) * (v3.xyz) + (r1.xyz);
    r8.xyz = normalize(r1.xyz);
    r2.xyz = normalize(v5.xyz);
    r1.xyz = (r7.xyz) * (r6.www) + (r4.xyz);
    r2.w = dot(r2.xyz, r8.xyz);
    r1.xyz = (r3.www) * (r1.xyz);
    r2.w = (r2.w) + (r2.w);
    r4.xyz = (r8.xyz) * (-(r2.www)) + (r2.xyz);
    r3.w = saturate(dot(r8.xyz, -(r2.xyz)));
    r2 = tex2D(s3, v6.zw);
    r2 = float4(((r4.w) >= 0.0f ? (r2.x) : (c0.z)), ((r4.w) >= 0.0f ? (r2.y) : (c0.z)), ((r4.w) >= 0.0f ? (r2.z) : (c0.z)), ((r4.w) >= 0.0f ? (r2.w) : (c0.y)));
    r0 = float4(((r4.w) >= 0.0f ? (r0.x) : (r5.x)), ((r4.w) >= 0.0f ? (r0.y) : (r5.y)), ((r4.w) >= 0.0f ? (r0.z) : (r5.z)), ((r4.w) >= 0.0f ? (r0.w) : (r5.w)));
    r4.w = (r2.w) * (c0.w);
    r4 = texCUBElod(s15, r4);
    r5.xyz = (r4.xyz) * (r4.xyz);
    r3.y = (-(r3.w)) + (c0.y);
    r3.x = (r3.y) * (r3.y);
    r3.w = (r2.w) * (c2.z) + (c2.w);
    r2.w = (r3.y) * (r3.x);
    r3.w = 1.0f / (r3.w);
    r2.w = (r2.w) * (r3.w);
    r4.xyz = (r2.xyz) * (-(r2.xyz)) + (c0.yyy);
    r6.xyz = (r3.zzz) * (r5.xyz);
    r3.xyz = (r2.www) * (r4.xyz);
    r9.xyz = (r2.xyz) * (r2.xyz) + (r3.xyz);
    r5 = (-(v5.yyyy)) + (c[6]);
    r2 = (r5) * (r5);
    r4 = (-(v5.xxxx)) + (c[5]);
    r2 = (r4) * (r4) + (r2);
    r3 = (-(v5.zzzz)) + (c[7]);
    r6.xyz = (r6.xyz) * (r9.xyz);
    r2 = (r3) * (r3) + (r2);
    r7.xyz = (r7.xyz) * (r6.xyz);
    r6.x = rsqrt(r2.x);
    r6.y = rsqrt(r2.y);
    r6.z = rsqrt(r2.z);
    r6.w = rsqrt(r2.w);
    r7.xyz = (r7.xyz) * (c0.www);
    r5 = (r5) * (r6);
    r5 = (r8.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r8.xxxx) + (r5);
    r5.z = c0.y;
    r2 = saturate((r2) * (c[8]) + (r5.zzzz));
    r3 = saturate((r3) * (r8.zzzz) + (r4));
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2 = (r2) * (r3);
    r3.xyz = (r0.xyz) * (r1.xyz) + (r7.xyz);
    r1.x = dot(c[9], r2);
    r1.y = dot(c[10], r2);
    r1.z = dot(c[11], r2);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v2.xyz);
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

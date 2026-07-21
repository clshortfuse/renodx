// Mechanically reconstructed from 0x8527DAB4.ps_3_0.cso.
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 8.0f);
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
    r4 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (c3.xy) + (c3.zy);
    r5 = tex2D(s13, r0.xy);
    r4.w = r5.y;
    r6.xy = (r4.yw) * (c4.xx) + (c4.yy);
    r1 = tex2D(s2, v6.zw);
    r0 = tex2D(s0, v0.xy);
    r1.z = (r0.w) * (v6.x) + (c1.x);
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r1.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r2 = float4(((r1.z) >= 0.0f ? (r0.x) : (c1.z)), ((r1.z) >= 0.0f ? (r0.y) : (c1.z)), ((r1.z) >= 0.0f ? (r0.z) : (c1.z)), ((r1.z) >= 0.0f ? (r0.w) : (c1.z)));
    r3 = (r2.wwww) * (c1.zzyy);
    r1.zw = c[5].xy;
    r0 = tex2D(s1, v6.zw);
    r6.w = (r0.w) * (v6.y) + (c1.x);
    r0.w = dot(r6.xy, r6.xy) + (c1.z);
    r3 = float4(((r6.w) >= 0.0f ? (r1.x) : (r3.x)), ((r6.w) >= 0.0f ? (r1.y) : (r3.y)), ((r6.w) >= 0.0f ? (r1.z) : (r3.z)), ((r6.w) >= 0.0f ? (r1.w) : (r3.w)));
    r1.w = exp2(-(r0.w));
    r0.w = dot(r3.xy, r3.xy) + (c1.z);
    r4.y = (r1.w) * (c2.x) + (c2.y);
    r1.w = exp2(-(r0.w));
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r4.w = (r1.w) * (c2.x) + (c2.y);
    r1 = tex2D(s14, v0.zw);
    r9.xy = (r1.xy) * (c3.ww);
    r4.y = (r4.y) * (r4.w);
    r5.xy = (r5.xz) * (r9.yy);
    r1.w = dot(r6.xy, r3.xy) + (c1.z);
    r1.z = (r1.y) * (c3.w) + (-(r5.x));
    r1.w = saturate((r1.w) * (r4.y) + (r4.y));
    r1.z = (r5.z) * (-(r9.y)) + (r1.z);
    r5.xz = (r5.xy) * (c4.xx);
    r5.y = (r1.z) + (r1.z);
    r5.xyz = (r1.www) * (r5.xyz);
    r4.xy = (r4.xz) * (r9.xx);
    r5.w = (r1.x) * (c3.w) + (-(r4.x));
    r1 = v1;
    r1.xyz = (r3.xxx) * (v4.xyz) + (r1.xyz);
    r6.xz = (r4.xy) * (c4.xx);
    r1.xyz = (r3.yyy) * (v3.xyz) + (r1.xyz);
    r7.xyz = normalize(r1.xyz);
    r8.xyz = normalize(v5.xyz);
    r1.y = (r4.z) * (-(r9.x)) + (r5.w);
    r1.z = dot(r8.xyz, r7.xyz);
    r6.y = (r1.y) + (r1.y);
    r3.y = (r1.z) + (r1.z);
    r1.xyz = (r6.xyz) * (r4.www) + (r5.xyz);
    r5.xyz = (r7.xyz) * (-(r3.yyy)) + (r8.xyz);
    r4 = tex2D(s3, v6.zw);
    r4 = float4(((r6.w) >= 0.0f ? (r4.x) : (c1.z)), ((r6.w) >= 0.0f ? (r4.y) : (c1.z)), ((r6.w) >= 0.0f ? (r4.z) : (c1.z)), ((r6.w) >= 0.0f ? (r4.w) : (c1.y)));
    r3.y = saturate(dot(r7.xyz, -(r8.xyz)));
    r5.w = (r4.w) * (c1.w);
    r5 = texCUBElod(s15, r5);
    r3.y = (-(r3.y)) + (c1.y);
    r5.w = (r3.y) * (r3.y);
    r3.x = (r4.w) * (c2.z) + (c2.w);
    r3.y = (r3.y) * (r5.w);
    r3.x = 1.0f / (r3.x);
    r3.y = (r3.y) * (r3.x);
    r8.xyz = (r4.xyz) * (-(r4.xyz)) + (c1.yyy);
    r7.xyz = (r5.xyz) * (r5.xyz);
    r5.xyz = (r3.yyy) * (r8.xyz);
    r3.xyz = (r3.zzz) * (r7.xyz);
    r4.xyz = (r4.xyz) * (r4.xyz) + (r5.xyz);
    r1.xyz = (r3.www) * (r1.xyz);
    r3.xyz = (r3.xyz) * (r4.xyz);
    r0 = float4(((r6.w) >= 0.0f ? (r0.x) : (r2.x)), ((r6.w) >= 0.0f ? (r0.y) : (r2.y)), ((r6.w) >= 0.0f ? (r0.z) : (r2.z)), ((r6.w) >= 0.0f ? (r0.w) : (r2.w)));
    r2.xyz = (r6.xyz) * (r3.xyz);
    r2.xyz = (r2.xyz) * (c1.www);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}

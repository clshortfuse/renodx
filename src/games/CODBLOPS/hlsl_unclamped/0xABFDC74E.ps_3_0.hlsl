// Mechanically reconstructed from 0xABFDC74E.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s12 : register(s12);
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
    const float4 c1 = float4(-0.5f, 1.0f, -0.0f, 0.200000003f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c3 = float4(1.0f, 0.5f, -0.0f, 31.875f);
    const float4 c4 = float4(0.0009765625f, 0.125f, 0.25f, 0.0f);
    const float4 c6 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c7 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0 = tex2D(s1, v1.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r2 = tex2D(s2, v1.xy);
    r1.zw = (r2.ww) * (c1.zy) + (c1.wz);
    r0 = tex2D(s0, v1.xy);
    r2.z = (r0.w) * (v0.w) + (c1.x);
    r0.w = dot(v6.xyz, v6.xyz);
    r3 = float4(((r2.z) >= 0.0f ? (r1.x) : (c1.z)), ((r2.z) >= 0.0f ? (r1.y) : (c1.z)), ((r2.z) >= 0.0f ? (r1.z) : (c1.z)), ((r2.z) >= 0.0f ? (r1.w) : (c1.y)));
    r0.w = rsqrt(r0.w);
    r1 = v2;
    r1.xyz = (r3.xxx) * (v5.xyz) + (r1.xyz);
    r9.xyz = (r0.www) * (v6.xyz);
    r4.xyz = (r3.yyy) * (v4.xyz) + (r1.xyz);
    r1.xyz = (v6.xyz) * (-(r0.www)) + (c[17].xyz);
    r8.xyz = normalize(r4.xyz);
    r4.w = saturate(dot(r8.xyz, -(r9.xyz)));
    r2.x = (r3.w) * (c2.w);
    r0.w = (r3.w) * (-(c6.z)) + (c6.w);
    r2.w = saturate(dot(r8.xyz, c[17].xyz));
    r4.z = (r4.w) * (r0.w) + (r2.x);
    r2.x = (r2.w) * (r0.w) + (r2.x);
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r2.x = (r2.x) * (r4.z) + (c4.x);
    r10.z = (-(r4.w)) + (c1.y);
    r2.x = 1.0f / (r2.x);
    r4.w = (r2.w) * (r2.x);
    r4.xyz = normalize(r1.xyz);
    r1.xyz = (r2.www) * (c[18].xyz);
    r5.w = saturate(dot(r8.xyz, r4.xyz));
    r2.x = saturate(dot(r4.xyz, c[17].xyz));
    r4.xy = (r3.ww) * (c7.xy) + (c7.zw);
    r2.w = exp2(r4.y);
    r2.x = (-(r2.x)) + (c1.y);
    r4.y = pow(abs(r5.w), r2.w);
    r4.z = (r2.x) * (r2.x);
    r2.w = (r2.w) * (c4.y) + (c4.z);
    r4.z = (r4.z) * (r4.z);
    r2.w = (r4.y) * (r2.w);
    r2.x = (r2.x) * (r4.z);
    r8.w = (r3.z) * (r3.z);
    r7.w = (r3.z) * (-(r3.z)) + (c1.y);
    r2.w = (r4.w) * (r2.w);
    r2.x = (r7.w) * (r2.x) + (r8.w);
    r2.w = (r2.w) * (r2.x);
    r9.w = ((r2.z) >= 0.0f ? (r2.y) : (c1.z));
    r10.w = 1.0f / (r4.x);
    r2.w = (r2.w) * (r9.w);
    r0 = float4(((r2.z) >= 0.0f ? (r0.x) : (c1.z)), ((r2.z) >= 0.0f ? (r0.y) : (c1.z)), ((r2.z) >= 0.0f ? (r0.z) : (c1.z)), ((r2.z) >= 0.0f ? (r0.w) : (c1.z)));
    r5.xyz = (r2.www) * (c[19].xyz);
    r2 = tex2D(s12, v1.zw);
    r4.xy = (v1.zw) * (c3.xy);
    r4 = tex2D(s13, r4.xy);
    r6.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r6 = tex2D(s13, r6.xy);
    r4.w = r6.y;
    r7.xyz = (r5.xyz) * (r2.yyy);
    r5.xy = (r4.yw) * (c6.xx) + (c6.yy);
    r2.z = dot(r3.xy, r3.xy) + (c1.z);
    r2.w = dot(r5.xy, r5.xy) + (c1.z);
    r2.z = exp2(-(r2.z));
    r2.w = exp2(-(r2.w));
    r2.z = (r2.z) * (c2.x) + (c2.y);
    r2.x = (r2.w) * (c2.x) + (c2.y);
    r2.w = dot(r5.xy, r3.xy) + (c1.z);
    r2.x = (r2.z) * (r2.x);
    r5 = tex2D(s14, v1.zw);
    r10.xy = (r5.xy) * (c3.ww);
    r2.x = saturate((r2.w) * (r2.x) + (r2.x));
    r3.xy = (r6.xz) * (r10.yy);
    r2.w = (r5.y) * (c3.w) + (-(r3.x));
    r3.xz = (r3.xy) * (c6.xx);
    r2.w = (r6.z) * (-(r10.y)) + (r2.w);
    r4.xy = (r4.xz) * (r10.xx);
    r3.y = (r2.w) + (r2.w);
    r2.w = (r5.x) * (c3.w) + (-(r4.x));
    r5.xyz = (r2.xxx) * (r3.xyz);
    r2.w = (r4.z) * (-(r10.x)) + (r2.w);
    r3.xz = (r4.xy) * (c6.xx);
    r3.y = (r2.w) + (r2.w);
    r2.w = (r3.w) * (c2.z);
    r4.xyz = (r3.xyz) * (r2.zzz) + (r5.xyz);
    r4.xyz = (r9.www) * (r4.xyz);
    r2.z = dot(r9.xyz, r8.xyz);
    r4.xyz = (r2.yyy) * (r1.xyz) + (r4.xyz);
    r2.z = (r2.z) + (r2.z);
    r1.xyz = (r0.xyz) * (v0.xyz);
    r2.xyz = (r8.xyz) * (-(r2.zzz)) + (r9.xyz);
    r2 = texCUBElod(s15, r2);
    r0.z = (r10.z) * (r10.z);
    r2.w = (r10.z) * (r0.z);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r2.w = (r10.w) * (r2.w);
    r0.xyz = (r9.www) * (r0.xyz);
    r2.w = (r7.w) * (r2.w) + (r8.w);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r2.www);
    r1.xyz = (r1.xyz) * (r4.xyz) + (r7.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c2.zzz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[5].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}

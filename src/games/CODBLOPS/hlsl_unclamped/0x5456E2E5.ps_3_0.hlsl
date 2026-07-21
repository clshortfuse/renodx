// Mechanically reconstructed from 0x5456E2E5.ps_3_0.cso.
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
    const float4 c1 = float4(0.0f, 0.600000024f, 0.400000006f, 8.0f);
    const float4 c2 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 0.0009765625f, 3.0f);
    const float4 c4 = float4(0.125f, 0.25f, 0.0f, 0.0f);
    const float4 c12 = float4(1.0f, 0.797884583f, 0.959999979f, 0.0399999991f);
    const float4 c13 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r1.xyz = (-(v6.xyz)) + (c[5].xyz);
    r3.y = dot(r1.xyz, r1.xyz);
    r0.w = rsqrt(r3.y);
    r7.xyz = normalize(v6.xyz);
    r0.xyz = (r1.xyz) * (r0.www) + (-(r7.xyz));
    r1.xyz = (r1.xyz) * (r0.www);
    r2.xyz = normalize(r0.xyz);
    r3.x = 1.0f / (r0.w);
    r1.w = saturate(dot(r2.xyz, r1.xyz));
    r0 = tex2D(s1, v1.xy);
    r9.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.w = (-(r1.w)) + (c12.x);
    r0.xyz = v2.xyz;
    r0.xyz = (r9.xxx) * (v5.xyz) + (r0.xyz);
    r1.w = (r0.w) * (r0.w);
    r0.xyz = (r9.yyy) * (v4.xyz) + (r0.xyz);
    r1.w = (r1.w) * (r1.w);
    r6.xyz = normalize(r0.xyz);
    r0.z = (r0.w) * (r1.w);
    r3.w = saturate(dot(r6.xyz, r1.xyz));
    r1 = tex2D(s2, v1.xy);
    r1.z = (r1.w) * (c12.y);
    r0.x = (r1.w) * (-(c12.y)) + (c12.x);
    r0.y = saturate(dot(r6.xyz, -(r7.xyz)));
    r0.w = (r3.w) * (r0.x) + (r1.z);
    r0.x = (r0.y) * (r0.x) + (r1.z);
    r0.z = (r0.z) * (c12.z) + (c12.w);
    r0.w = (r0.w) * (r0.x) + (c3.z);
    r1.x = (-(r0.y)) + (c12.x);
    r0.w = 1.0f / (r0.w);
    r2.w = (r3.w) * (r0.w);
    r0.xy = (r1.ww) * (c13.xy) + (c13.zw);
    r2.z = saturate(dot(r6.xyz, r2.xyz));
    r1.z = exp2(r0.y);
    r0.y = pow(abs(r2.z), r1.z);
    r0.w = (r1.z) * (c4.x) + (c4.y);
    r8.xyz = (r3.www) * (c[6].xyz);
    r0.w = (r0.y) * (r0.w);
    r1.z = 1.0f / (r0.x);
    r0.w = (r2.w) * (r0.w);
    r0.z = (r0.z) * (r0.w);
    r2.xy = saturate((r3.xx) * (c[9].xy) + (c[9].zw));
    r0.xy = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c3.yy) + (c3.ww);
    r0.w = dot(c[8].yz, r3.xy) + (c[8].x);
    r0.xy = (r0.xy) * (r2.xy);
    r0.z = (r1.y) * (r0.z);
    r0.w = (r0.w) * (r0.x);
    r5.xyz = (r0.zzz) * (c[7].xyz);
    r5.w = (r0.y) * (r0.w);
    r0 = tex2D(s12, v1.zw);
    r2.xy = (v1.zw) * (c2.xy);
    r2 = tex2D(s13, r2.xy);
    r3.xy = (v1.zw) * (c2.xy) + (c2.zy);
    r4 = tex2D(s13, r3.xy);
    r2.w = r4.y;
    r3.xy = (r2.yw) * (c3.xx) + (c3.yy);
    r0.w = dot(r9.xy, r9.xy) + (c1.x);
    r0.z = dot(r3.xy, r3.xy) + (c1.x);
    r0.w = exp2(-(r0.w));
    r0.z = exp2(-(r0.z));
    r0.w = (r0.w) * (c1.y) + (c1.z);
    r0.x = (r0.z) * (c1.y) + (c1.z);
    r0.z = dot(r3.xy, r9.xy) + (c1.x);
    r0.x = (r0.w) * (r0.x);
    r3 = tex2D(s14, v1.zw);
    r10.xy = (r3.xy) * (c2.ww);
    r0.x = saturate((r0.z) * (r0.x) + (r0.x));
    r4.xy = (r4.xz) * (r10.yy);
    r0.z = (r3.y) * (c2.w) + (-(r4.x));
    r9.xz = (r4.xy) * (c3.xx);
    r0.z = (r4.z) * (-(r10.y)) + (r0.z);
    r2.xy = (r2.xz) * (r10.xx);
    r9.y = (r0.z) + (r0.z);
    r0.z = (r3.x) * (c2.w) + (-(r2.x));
    r4.xyz = (r0.xxx) * (r9.xyz);
    r0.z = (r2.z) * (-(r10.x)) + (r0.z);
    r3.xz = (r2.xy) * (c3.xx);
    r3.y = (r0.z) + (r0.z);
    r2.xyz = (r3.xyz) * (r0.www) + (r4.xyz);
    r0.w = (r5.w) * (r0.y);
    r0.xyz = (r1.yyy) * (r2.xyz);
    r5.xyz = (r5.xyz) * (r0.www);
    r4.xyz = (r0.www) * (r8.xyz) + (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r2.w = dot(r7.xyz, r6.xyz);
    r0 = (r0.wxyz) * (v0.wxyz);
    r2.w = (r2.w) + (r2.w);
    r2.xyz = (r6.xyz) * (-(r2.www)) + (r7.xyz);
    r2.w = (r1.w) * (c1.w);
    r2 = texCUBElod(s15, r2);
    r1.w = (r1.x) * (r1.x);
    r1.w = (r1.x) * (r1.w);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r1.z) * (r1.w);
    r1.xyz = (r1.yyy) * (r2.xyz);
    r1.w = (r1.w) * (c12.z) + (c12.w);
    r2.xyz = (r0.yzw) * (r0.yzw);
    r1.xyz = (r1.xyz) * (r1.www);
    r2.xyz = (r2.xyz) * (r4.xyz) + (r5.xyz);
    r1.xyz = (r3.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c1.www) + (r2.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r0.w = (r0.x) * (c[10].w);
    r0.xyz = max(((r1.xyz) * (c[11].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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

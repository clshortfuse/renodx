// Mechanically reconstructed from 0x991B0A5B.ps_3_0.cso.
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
    const float4 c1 = float4(0.200000003f, 0.0f, 0.600000024f, 0.400000006f);
    const float4 c2 = float4(8.0f, 1.0f, 0.797884583f, 0.5f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c4 = float4(0.125f, 0.25f, 0.0f, 0.0f);
    const float4 c12 = float4(4.0f, -2.0f, 0.0009765625f, 3.0f);
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
    float4 r11 = 0.0f;
    float4 r12 = 0.0f;
    float4 oC0 = 0.0f;

    r2.xyz = (-(v6.xyz)) + (c[5].xyz);
    r3.y = dot(r2.xyz, r2.xyz);
    r3.w = rsqrt(r3.y);
    r3.x = 1.0f / (r3.w);
    r1.xy = saturate((r3.xx) * (c[9].xy) + (c[9].zw));
    r0.xy = (r1.xy) * (r1.xy);
    r1.xy = (r1.xy) * (c12.yy) + (c12.ww);
    r0.w = dot(c[8].yz, r3.xy) + (c[8].x);
    r0.xy = (r0.xy) * (r1.xy);
    r0.w = (r0.w) * (r0.x);
    r2.w = (r0.y) * (r0.w);
    r1 = tex2D(s12, v1.zw);
    r0 = tex2D(s1, v1.xy);
    r5.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = v2;
    r0.xyz = (r5.xxx) * (v5.xyz) + (r0.xyz);
    r4.xyz = (r5.yyy) * (v4.xyz) + (r0.xyz);
    r3.xyz = (r2.xyz) * (r3.www);
    r0.xyz = normalize(r4.xyz);
    r6.w = (r2.w) * (r1.y);
    r2.w = saturate(dot(r0.xyz, r3.xyz));
    r1 = tex2D(s2, v1.xy);
    r4.y = (r1.w) * (c2.z);
    r9.xyz = normalize(v6.xyz);
    r4.w = (r1.w) * (-(c2.z)) + (c2.y);
    r4.z = saturate(dot(r0.xyz, -(r9.xyz)));
    r1.z = (r2.w) * (r4.w) + (r4.y);
    r4.w = (r4.z) * (r4.w) + (r4.y);
    r5.w = (-(r4.z)) + (c2.y);
    r1.z = (r1.z) * (r4.w) + (c12.z);
    r1.z = 1.0f / (r1.z);
    r4.xyz = (r2.xyz) * (r3.www) + (-(r9.xyz));
    r3.w = (r2.w) * (r1.z);
    r2.xyz = normalize(r4.xyz);
    r10.xyz = (r2.www) * (c[6].xyz);
    r4.w = saturate(dot(r0.xyz, r2.xyz));
    r2.w = saturate(dot(r2.xyz, r3.xyz));
    r2.xy = (r1.ww) * (c13.xy) + (c13.zw);
    r3.z = exp2(r2.y);
    r1.z = 1.0f / (r2.x);
    r2.x = pow(abs(r4.w), r3.z);
    r2.w = (-(r2.w)) + (c2.y);
    r2.y = (r3.z) * (c4.x) + (c4.y);
    r2.z = (r2.w) * (r2.w);
    r2.y = (r2.x) * (r2.y);
    r2.z = (r2.z) * (r2.z);
    r3.w = (r3.w) * (r2.y);
    r4.w = (r2.w) * (r2.z);
    r2 = tex2D(s0, v1.xy);
    r3.xyz = lerp(r2.xyz, c1.xxx, r1.xxx);
    r8.xyz = (r3.xyz) * (r3.xyz);
    r7.xyz = (r3.xyz) * (-(r3.xyz)) + (c2.yyy);
    r6.xyz = (r1.xxx) * (r2.xyz);
    r2.xyz = (r7.xyz) * (r4.www) + (r8.xyz);
    r3.xyz = (r3.www) * (r2.xyz);
    r2.xy = (v1.zw) * (c2.yw);
    r2 = tex2D(s13, r2.xy);
    r4.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r4 = tex2D(s13, r4.xy);
    r2.w = r4.y;
    r11.xyz = (r1.yyy) * (r3.xyz);
    r3.xy = (r2.yw) * (c12.xx) + (c12.yy);
    r1.x = dot(r5.xy, r5.xy) + (c1.y);
    r2.w = dot(r3.xy, r3.xy) + (c1.y);
    r1.x = exp2(-(r1.x));
    r2.w = exp2(-(r2.w));
    r1.x = (r1.x) * (c1.z) + (c1.w);
    r2.y = (r2.w) * (c1.z) + (c1.w);
    r2.w = dot(r3.xy, r5.xy) + (c1.y);
    r2.y = (r1.x) * (r2.y);
    r3 = tex2D(s14, v1.zw);
    r12.xy = (r3.xy) * (c3.ww);
    r3.w = saturate((r2.w) * (r2.y) + (r2.y));
    r4.xy = (r4.xz) * (r12.yy);
    r2.w = (r3.y) * (c3.w) + (-(r4.x));
    r5.xz = (r4.xy) * (c12.xx);
    r2.w = (r4.z) * (-(r12.y)) + (r2.w);
    r2.xy = (r2.xz) * (r12.xx);
    r5.y = (r2.w) + (r2.w);
    r2.w = (r3.x) * (c3.w) + (-(r2.x));
    r5.xyz = (r3.www) * (r5.xyz);
    r2.w = (r2.z) * (-(r12.x)) + (r2.w);
    r3.xz = (r2.xy) * (c12.xx);
    r3.y = (r2.w) + (r2.w);
    r4.xyz = (r11.xyz) * (c[7].xyz);
    r2.xyz = (r3.xyz) * (r1.xxx) + (r5.xyz);
    r5.xyz = (r6.www) * (r4.xyz);
    r2.xyz = (r1.yyy) * (r2.xyz);
    r4.xyz = (r6.www) * (r10.xyz) + (r2.xyz);
    r1.x = dot(r9.xyz, r0.xyz);
    r6.xyz = (r6.xyz) * (v0.xyz);
    r1.x = (r1.x) + (r1.x);
    r2.xyz = (r0.xyz) * (-(r1.xxx)) + (r9.xyz);
    r2.w = (r1.w) * (c2.x);
    r2 = texCUBElod(s15, r2);
    r0.z = (r5.w) * (r5.w);
    r1.w = (r5.w) * (r0.z);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r1.z) * (r1.w);
    r0.xyz = (r1.yyy) * (r0.xyz);
    r2.xyz = (r7.xyz) * (r1.www) + (r8.xyz);
    r1.xyz = (r6.xyz) * (r6.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r4.xyz) + (r5.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c2.xxx) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[11].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[10].w;

    return oC0;
}

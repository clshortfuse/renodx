// Mechanically reconstructed from 0x3373F5A2.ps_3_0.cso.
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
    const float4 c6 = float4(4.0f, -2.0f, 0.0009765625f, 0.0f);
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
    float4 r11 = 0.0f;
    float4 r12 = 0.0f;
    float4 r13 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s1, v1.xy);
    r12.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r1.w = dot(v6.xyz, v6.xyz);
    r0 = v2;
    r0.xyz = (r12.xxx) * (v5.xyz) + (r0.xyz);
    r1.w = rsqrt(r1.w);
    r1.xyz = (r12.yyy) * (v4.xyz) + (r0.xyz);
    r9.xyz = (r1.www) * (v6.xyz);
    r0.xyz = normalize(r1.xyz);
    r3.xyz = (v6.xyz) * (-(r1.www)) + (c[17].xyz);
    r2.z = saturate(dot(r0.xyz, -(r9.xyz)));
    r1 = tex2D(s2, v1.xy);
    r2.y = (r1.w) * (c2.z);
    r1.z = (r1.w) * (-(c2.z)) + (c2.y);
    r3.w = saturate(dot(r0.xyz, c[17].xyz));
    r2.w = (r2.z) * (r1.z) + (r2.y);
    r1.z = (r3.w) * (r1.z) + (r2.y);
    r6.w = (-(r2.z)) + (c2.y);
    r1.z = (r1.z) * (r2.w) + (c6.z);
    r1.z = 1.0f / (r1.z);
    r2.xyz = normalize(r3.xyz);
    r4.z = (r3.w) * (r1.z);
    r3.z = saturate(dot(r0.xyz, r2.xyz));
    r2.w = saturate(dot(r2.xyz, c[17].xyz));
    r4.xy = (r1.ww) * (c7.xy) + (c7.zw);
    r1.z = exp2(r4.y);
    r2.w = (-(r2.w)) + (c2.y);
    r2.y = pow(abs(r3.z), r1.z);
    r2.z = (r2.w) * (r2.w);
    r1.z = (r1.z) * (c4.x) + (c4.y);
    r2.z = (r2.z) * (r2.z);
    r1.z = (r2.y) * (r1.z);
    r4.w = (r2.w) * (r2.z);
    r2 = tex2D(s0, v1.xy);
    r3.xyz = lerp(r2.xyz, c1.xxx, r1.xxx);
    r8.xyz = (r3.xyz) * (r3.xyz);
    r7.xyz = (r3.xyz) * (-(r3.xyz)) + (c2.yyy);
    r1.z = (r4.z) * (r1.z);
    r3.xyz = (r7.xyz) * (r4.www) + (r8.xyz);
    r10.xyz = (r3.www) * (c[18].xyz);
    r3.xyz = (r1.zzz) * (r3.xyz);
    r1.z = 1.0f / (r4.x);
    r3.xyz = (r1.yyy) * (r3.xyz);
    r6.xyz = (r1.xxx) * (r2.xyz);
    r11.xyz = (r3.xyz) * (c[19].xyz);
    r2 = tex2D(s12, v1.zw);
    r3.xy = (v1.zw) * (c2.yw);
    r3 = tex2D(s13, r3.xy);
    r4.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r5 = tex2D(s13, r4.xy);
    r3.w = r5.y;
    r4.xy = (r3.yw) * (c6.xx) + (c6.yy);
    r1.x = dot(r12.xy, r12.xy) + (c1.y);
    r2.w = dot(r4.xy, r4.xy) + (c1.y);
    r1.x = exp2(-(r1.x));
    r2.w = exp2(-(r2.w));
    r1.x = (r1.x) * (c1.z) + (c1.w);
    r2.z = (r2.w) * (c1.z) + (c1.w);
    r2.w = dot(r4.xy, r12.xy) + (c1.y);
    r2.z = (r1.x) * (r2.z);
    r4 = tex2D(s14, v1.zw);
    r13.xy = (r4.xy) * (c3.ww);
    r2.z = saturate((r2.w) * (r2.z) + (r2.z));
    r5.xy = (r5.xz) * (r13.yy);
    r2.w = (r4.y) * (c3.w) + (-(r5.x));
    r12.xz = (r5.xy) * (c6.xx);
    r2.w = (r5.z) * (-(r13.y)) + (r2.w);
    r3.xy = (r3.xz) * (r13.xx);
    r12.y = (r2.w) + (r2.w);
    r2.w = (r4.x) * (c3.w) + (-(r3.x));
    r4.xyz = (r2.zzz) * (r12.xyz);
    r2.w = (r3.z) * (-(r13.x)) + (r2.w);
    r3.xz = (r3.xy) * (c6.xx);
    r3.y = (r2.w) + (r2.w);
    r4.xyz = (r3.xyz) * (r1.xxx) + (r4.xyz);
    r5.xyz = (r11.xyz) * (r2.yyy);
    r4.xyz = (r1.yyy) * (r4.xyz);
    r4.xyz = (r2.yyy) * (r10.xyz) + (r4.xyz);
    r1.x = dot(r9.xyz, r0.xyz);
    r6.xyz = (r6.xyz) * (v0.xyz);
    r1.x = (r1.x) + (r1.x);
    r2.xyz = (r0.xyz) * (-(r1.xxx)) + (r9.xyz);
    r2.w = (r1.w) * (c2.x);
    r2 = texCUBElod(s15, r2);
    r0.z = (r6.w) * (r6.w);
    r1.w = (r6.w) * (r0.z);
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
    r0.xyz = max(((r0.xyz) * (c[5].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c2.y;

    return oC0;
}

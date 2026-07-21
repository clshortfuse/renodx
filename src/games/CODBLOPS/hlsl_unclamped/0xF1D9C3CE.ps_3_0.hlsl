// Mechanically reconstructed from 0xF1D9C3CE.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
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
    float4 v4 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(8.0f, 1.0f, 0.797884583f, 0.5f);
    const float4 c1 = float4(0.959999979f, 0.0399999991f, 31.875f, 4.0f);
    const float4 c2 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 0.0009765625f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c12 = float4(0.125f, 0.25f, 0.0f, 0.0f);
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

    r0.w = dot(v4.xyz, v4.xyz);
    r1.w = rsqrt(r0.w);
    r0.xyz = (v4.xyz) * (-(r1.www)) + (c[17].xyz);
    r1.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r1.xyz, c[17].xyz));
    r7.xyz = (r1.www) * (v4.xyz);
    r2.z = (-(r0.w)) + (c0.y);
    r0.w = (r2.z) * (r2.z);
    r9.xyz = normalize(v2.xyz);
    r2.y = (r0.w) * (r0.w);
    r2.w = saturate(dot(r9.xyz, -(r7.xyz)));
    r0 = tex2D(s1, v1.xy);
    r2.x = (r0.w) * (c0.z);
    r0.z = (r0.w) * (-(c0.z)) + (c0.y);
    r1.w = saturate(dot(r9.xyz, c[17].xyz));
    r0.x = (r2.w) * (r0.z) + (r2.x);
    r0.z = (r1.w) * (r0.z) + (r2.x);
    r2.z = (r2.z) * (r2.y);
    r0.z = (r0.z) * (r0.x) + (c3.w);
    r0.x = 1.0f / (r0.z);
    r2.xy = (r0.ww) * (c4.xy) + (c4.zw);
    r3.w = saturate(dot(r9.xyz, r1.xyz));
    r0.z = exp2(r2.y);
    r1.z = pow(abs(r3.w), r0.z);
    r0.z = (r0.z) * (c12.x) + (c12.y);
    r0.x = (r1.w) * (r0.x);
    r0.z = (r1.z) * (r0.z);
    r1.z = (r2.z) * (c1.x) + (c1.y);
    r0.x = (r0.x) * (r0.z);
    r0.z = (-(r2.w)) + (c0.y);
    r0.x = (r1.z) * (r0.x);
    r10.xyz = (r1.www) * (c[18].xyz);
    r0.x = (r0.y) * (r0.x);
    r6.w = 1.0f / (r2.x);
    r2.xyz = (r0.xxx) * (c[19].xyz);
    r1 = tex2D(s12, v1.zw);
    r6.xyz = (r2.xyz) * (r1.yyy);
    r2 = tex2D(s0, v1.xy);
    r3.xy = (v1.zw) * (c0.yw);
    r3 = tex2D(s13, r3.xy);
    r4.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r5 = tex2D(s13, r4.xy);
    r3.w = r5.y;
    r4.xy = (r3.yw) * (c2.xx) + (c2.yy);
    r0.x = dot(r4.xy, r4.xy) + (c3.z);
    r4 = tex2D(s14, v1.zw);
    r8.xy = (r4.xy) * (c1.zz);
    r0.x = exp2(-(r0.x));
    r5.xy = (r5.xz) * (r8.yy);
    r0.x = saturate((r0.x) * (c2.z) + (c2.w));
    r1.w = (r4.y) * (c1.z) + (-(r5.x));
    r11.xz = (r5.xy) * (c1.ww);
    r3.xy = (r3.xz) * (r8.xx);
    r1.z = (r5.z) * (-(r8.y)) + (r1.w);
    r1.w = (r4.x) * (c1.z) + (-(r3.x));
    r11.y = (r1.z) + (r1.z);
    r1.w = (r3.z) * (-(r8.x)) + (r1.w);
    r8.xz = (r3.xy) * (c1.ww);
    r8.y = (r1.w) + (r1.w);
    r3.xyz = (r2.xyz) * (v0.xyz);
    r2.xyz = (r11.xyz) * (r0.xxx) + (r8.xyz);
    r5.xyz = (r3.xyz) * (r3.xyz);
    r2.xyz = (r0.yyy) * (r2.xyz);
    r1.xyz = (r1.yyy) * (r10.xyz) + (r2.xyz);
    r0.x = dot(r7.xyz, r9.xyz);
    r6.xyz = (r5.xyz) * (r1.xyz) + (r6.xyz);
    r0.x = (r0.x) + (r0.x);
    r1.xyz = (r9.xyz) * (-(r0.xxx)) + (r7.xyz);
    r1.w = (r0.w) * (c0.x);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r7.xyz = (r0.yyy) * (r1.xyz);
    r0.w = (r0.z) * (r0.z);
    r4.w = (r0.z) * (r0.w);
    r3 = (-(v4.yyyy)) + (c[6]);
    r0 = (r3) * (r3);
    r2 = (-(v4.xxxx)) + (c[5]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v4.zzzz)) + (c[7]);
    r4.w = (r6.w) * (r4.w);
    r0 = (r1) * (r1) + (r0);
    r5.w = (r4.w) * (c1.x) + (c1.y);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r7.xyz = (r7.xyz) * (r5.www);
    r3 = (r3) * (r4);
    r3 = (r9.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r9.xxxx) + (r3);
    r3.z = c0.y;
    r0 = saturate((r0) * (c[8]) + (r3.zzzz));
    r1 = saturate((r1) * (r9.zzzz) + (r2));
    r2.xyz = (r8.xyz) * (r7.xyz);
    r0 = (r0) * (r1);
    r2.xyz = (r2.xyz) * (c0.xxx) + (r6.xyz);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r1.z = dot(c[11], r0);
    r0.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}

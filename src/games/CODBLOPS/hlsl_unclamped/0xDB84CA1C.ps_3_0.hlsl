// Mechanically reconstructed from 0xDB84CA1C.ps_3_0.cso.
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
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(-1.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c1 = float4(0.797884583f, 1.0f, 0.5f, 0.0f);
    const float4 c2 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 0.125f, 0.25f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0 = tex2D(s0, v0.xy);
    r1 = tex2D(s1, v4.zw);
    r0.w = dot(v3.xyz, v3.xyz);
    r1.w = rsqrt(r0.w);
    r1.xyz = (r1.xyz) + (c0.xxx);
    r3.xyz = (v3.xyz) * (-(r1.www)) + (c[17].xyz);
    r2.xyz = (v4.yyy) * (r1.xyz) + (c0.yyy);
    r1.xyz = normalize(r3.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r0.w = saturate(dot(r1.xyz, c[17].xyz));
    r2.xyz = (r2.xyz) * (c0.zzz);
    r0.w = (-(r0.w)) + (c0.y);
    r5.xyz = (r0.xyz) * (r0.xyz);
    r0.z = (r0.w) * (r0.w);
    r7.xyz = (r1.www) * (v3.xyz);
    r0.z = (r0.z) * (r0.z);
    r3.w = (r0.w) * (r0.z);
    r9.xyz = normalize(v1.xyz);
    r11.xyz = (r2.xyz) * (r2.xyz);
    r2.w = saturate(dot(r9.xyz, -(r7.xyz)));
    r0 = tex2D(s2, v0.xy);
    r3.z = (r0.w) * (c1.x);
    r0.z = (r0.w) * (-(c1.x)) + (c1.y);
    r0.x = saturate(dot(r9.xyz, c[17].xyz));
    r1.w = (r2.w) * (r0.z) + (r3.z);
    r0.z = (r0.x) * (r0.z) + (r3.z);
    r10.xyz = (r2.xyz) * (-(r2.xyz)) + (c0.yyy);
    r0.z = (r0.z) * (r1.w) + (c2.w);
    r1.w = 1.0f / (r0.z);
    r2.xy = (r0.ww) * (c4.xy) + (c4.zw);
    r2.z = saturate(dot(r9.xyz, r1.xyz));
    r0.z = exp2(r2.y);
    r1.z = pow(abs(r2.z), r0.z);
    r0.z = (r0.z) * (c3.z) + (c3.w);
    r1.w = (r0.x) * (r1.w);
    r0.z = (r1.z) * (r0.z);
    r1.xyz = (r10.xyz) * (r3.www) + (r11.xyz);
    r1.w = (r1.w) * (r0.z);
    r0.z = (-(r2.w)) + (c0.y);
    r1.xyz = (r1.xyz) * (r1.www);
    r6.xyz = (r0.xxx) * (c[18].xyz);
    r1.xyz = (r0.yyy) * (r1.xyz);
    r5.w = 1.0f / (r2.x);
    r12.xyz = (r1.xyz) * (c[19].xyz);
    r1 = tex2D(s12, v0.zw);
    r2.xy = (v0.zw) * (c1.yz);
    r2 = tex2D(s13, r2.xy);
    r3.xy = (v0.zw) * (c1.yz) + (c1.wz);
    r4 = tex2D(s13, r3.xy);
    r2.w = r4.y;
    r3.xy = (r2.yw) * (c2.yy) + (c2.zz);
    r0.x = dot(r3.xy, r3.xy) + (c1.w);
    r3 = tex2D(s14, v0.zw);
    r8.xy = (r3.xy) * (c2.xx);
    r0.x = exp2(-(r0.x));
    r4.xy = (r4.xz) * (r8.yy);
    r0.x = saturate((r0.x) * (c3.x) + (c3.y));
    r1.w = (r3.y) * (c2.x) + (-(r4.x));
    r13.xz = (r4.xy) * (c2.yy);
    r2.xy = (r2.xz) * (r8.xx);
    r1.z = (r4.z) * (-(r8.y)) + (r1.w);
    r1.w = (r3.x) * (c2.x) + (-(r2.x));
    r13.y = (r1.z) + (r1.z);
    r1.w = (r2.z) * (-(r8.x)) + (r1.w);
    r8.xz = (r2.xy) * (c2.yy);
    r8.y = (r1.w) + (r1.w);
    r3.xyz = (r13.xyz) * (r0.xxx) + (r8.xyz);
    r2.xyz = (r12.xyz) * (r1.yyy);
    r3.xyz = (r0.yyy) * (r3.xyz);
    r1.xyz = (r1.yyy) * (r6.xyz) + (r3.xyz);
    r0.x = dot(r7.xyz, r9.xyz);
    r6.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0.x = (r0.x) + (r0.x);
    r1.xyz = (r9.xyz) * (-(r0.xxx)) + (r7.xyz);
    r1.w = (r0.w) * (c0.w);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r7.xyz = (r0.yyy) * (r1.xyz);
    r0.w = (r0.z) * (r0.z);
    r4.w = (r0.z) * (r0.w);
    r3 = (-(v3.yyyy)) + (c[6]);
    r0 = (r3) * (r3);
    r2 = (-(v3.xxxx)) + (c[5]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v3.zzzz)) + (c[7]);
    r4.w = (r5.w) * (r4.w);
    r0 = (r1) * (r1) + (r0);
    r10.xyz = (r10.xyz) * (r4.www) + (r11.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r7.xyz = (r7.xyz) * (r10.xyz);
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
    r2.xyz = (r2.xyz) * (c0.www) + (r6.xyz);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r1.z = dot(c[11], r0);
    r0.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
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
